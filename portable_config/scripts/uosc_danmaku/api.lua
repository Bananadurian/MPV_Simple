local msg = require('mp.msg')
local utils = require("mp.utils")
local md5 = require("md5")

local danmaku_path = os.getenv("TEMP") or "/tmp/"
local exec_path = mp.command_native({ "expand-path", options.DanmakuFactory_Path })
local history_path = mp.command_native({"expand-path", options.history_path})
local blacklist_file = mp.command_native({ "expand-path", options.blacklist_path })

danmaku = {sources = {}, count = 1}

-- url编码转换
function url_encode(str)
    -- 将非安全字符转换为百分号编码
    if str then
        str = str:gsub("([^%w%-%.%_%~])", function(c)
            return string.format("%%%02X", string.byte(c))
        end)
    end
    return str
end

function hex_to_char(x)
    return string.char(tonumber(x, 16))
end

-- url解码转换
function url_decode(str)
    if str ~= nil then
        str = str:gsub('^%a[%a%d-_]+://', '')
              :gsub('^%a[%a%d-_]+:\\?', '')
              :gsub('%%(%x%x)', hex_to_char)
        if str:find('://localhost:?') then
            str = str:gsub('^.*/', '')
        end
        str = str:gsub('%?.+', '')
              :gsub('%+', ' ')
        return str
    end
end

function remove_query(url)
    local qpos = string.find(url, "?", 1, true)
    if qpos then
        return string.sub(url, 1, qpos - 1)
    else
        return url
    end
end

function is_protocol(path)
    return type(path) == 'string' and (path:find('^%a[%w.+-]-://') ~= nil or path:find('^%a[%w.+-]-:%?') ~= nil)
end

function file_exists(path)
    if path then
        local meta = utils.file_info(path)
        return meta and meta.is_file
    end
    return false
end

local function get_cid()
    local cid, danmaku_id = nil, nil
    local tracks = mp.get_property_native("track-list")
    for _, track in ipairs(tracks) do
        if track["lang"] == "danmaku" then
            cid = track["external-filename"]:match("/(%d-)%.xml$")
            danmaku_id = track["id"]
            break
        end
    end
    return cid, danmaku_id
end

function extract_between_colons(input_string)
    local start_index = 0
    local end_index = 0
    local count = 0
    for i = 1, #input_string do
        if input_string:sub(i, i) == ":" then
            count = count + 1
            if count == 2 then
                start_index = i
            elseif count == 3 then
                end_index = i
                break
            end
        end
    end
    if start_index > 0 and end_index > 0 then
        return input_string:sub(start_index + 1, end_index - 1)
    else
        return nil
    end
end


function hex_to_int_color(hex_color)
    -- 移除颜色代码中的'#'字符
    hex_color = hex_color:sub(2)  -- 只保留颜色代码部分

    -- 提取R, G, B的十六进制值并转为整数
    local r = tonumber(hex_color:sub(1, 2), 16)
    local g = tonumber(hex_color:sub(3, 4), 16)
    local b = tonumber(hex_color:sub(5, 6), 16)

    -- 计算32位整数值
    local color_int = (r * 256 * 256) + (g * 256) + b

    return color_int
end


function get_type_from_position(position)
    if position == 0 then
        return 1
    end
    if position == 1 then
        return 4
    end
    return 5
end

--读history 和 写history
function read_file(file_path)
    local file = io.open(file_path, "r") -- 打开文件，"r"表示只读模式
    if not file then
        return nil
    end
    local content = file:read("*all") -- 读取文件所有内容
    file:close()                      -- 关闭文件
    return content
end

function write_json_file(file_path, data)
    local file = io.open(file_path, "w")
    if not file then
        return
    end
    file:write(utils.format_json(data)) -- 将 Lua 表转换为 JSON 并写入
    file:close()
end

function write_history(episodeid)
    local history = {}
    local path = mp.get_property("path")
    local dir = get_parent_directory(path)
    local fname = mp.get_property('filename/no-ext')
    local episodeNumber = 0
    if episodeid then
        episodeNumber = tonumber(episodeid) % 1000
    elseif danmaku.extra then
        episodeNumber = danmaku.extra.episodenum
    end

    if is_protocol(path) then
        local title, season_num, episod_num = parse_title()
        if title and episod_num then
            if season_num then
                dir = title .." Season".. season_num
            else
                dir = title
            end
            fname = url_decode(mp.get_property("media-title"))
            episodeNumber = episod_num
        end
    end

    if dir ~= nil then
        local history_json = read_file(history_path)
        if history_json ~= nil then
            history = utils.parse_json(history_json) or {}
        end
        history[dir] = {}
        history[dir].fname = fname
        history[dir].source = danmaku.source
        history[dir].animeTitle = danmaku.anime
        history[dir].episodeTitle = danmaku.episode
        history[dir].episodeNumber = episodeNumber
        if episodeid then
            history[dir].episodeId = episodeid
        elseif danmaku.extra then
            history[dir].extra = danmaku.extra
        end
        write_json_file(history_path, history)
    end
end

function itable_index_of(itable, value)
    for index = 1, #itable do
        if itable[index] == value then
            return index
        end
    end
end

platform = (function()
    local platform = mp.get_property_native("platform")
    if platform then
        if itable_index_of({ "windows", "darwin" }, platform) then
            return platform
        end
    else
        if os.getenv("windir") ~= nil then
            return "windows"
        end
        local homedir = os.getenv("HOME")
        if homedir ~= nil and string.sub(homedir, 1, 6) == "/Users" then
            return "darwin"
        end
    end
    return "linux"
end)()

function get_danmaku_visibility()
    local history_json = read_file(history_path)
    local history
    if history_json ~= nil then
        history = utils.parse_json(history_json)
        local flag = history["show_danmaku"]
        if flag == nil then
            history["show_danmaku"] = false
            write_json_file(history_path, history)
        else
            return flag
        end
    else
        history = {}
        history["show_danmaku"] = false
        write_json_file(history_path, history)
    end
    return false
end

function set_danmaku_visibility(flag)
    local history = {}
    local history_json = read_file(history_path)
    if history_json ~= nil then
        history = utils.parse_json(history_json)
    end
    history["show_danmaku"] = flag
    write_json_file(history_path, history)
end

function set_danmaku_button()
    if get_danmaku_visibility() then
        mp.commandv("script-message-to", "uosc", "set", "show_danmaku", "on")
    end
end

-- 拆分字符串中的字符和数字
local function split_by_numbers(filename)
    local parts = {}
    local pattern = "([^%d]*)(%d+)([^%d]*)"
    for pre, num, post in string.gmatch(filename, pattern) do
        table.insert(parts, {pre = pre, num = tonumber(num), post = post})
    end
    return parts
end

-- 识别并匹配前后剧集
local function compare_filenames(fname1, fname2)
    local parts1 = split_by_numbers(fname1)
    local parts2 = split_by_numbers(fname2)

    local min_len = math.min(#parts1, #parts2)

    -- 逐个部分进行比较
    for i = 1, min_len do
        local part1 = parts1[i]
        local part2 = parts2[i]

        -- 比较数字前的字符是否相同
        if part1.pre ~= part2.pre then
            return false
        end

        -- 比较数字部分
        if part1.num ~= part2.num then
            return part1.num, part2.num
        end

        -- 比较数字后的字符是否相同
        if part1.post ~= part2.post then
            return false
        end
    end

    return false
end

-- 规范化路径
function normalize(path)
    if normalize_path ~= nil then
        if normalize_path then
            path = mp.command_native({"normalize-path", path})
        else
            local directory = mp.get_property("working-directory", "")
            path = utils.join_path(directory, path:gsub('^%.[\\/]',''))
            if platform == "windows" then path = path:gsub("\\", "/") end
        end
        return path
    end

    normalize_path = false

    local commands = mp.get_property_native("command-list", {})
    for _, command in ipairs(commands) do
        if command.name == "normalize-path" then
            normalize_path = true
            break
        end
    end
    return normalize(path)
end

-- 获取父目录路径
function get_parent_directory(path)
    local dir = nil
    if path and not is_protocol(path) then
        path = normalize(path)
        dir = utils.split_path(path)
    end
    return dir
end

-- 获取播放文件标题信息
function parse_title(from_menu)
    local path = mp.get_property("path")
    local filename = mp.get_property("filename/no-ext")

    if not filename then
        return
    end
    local thin_space = string.char(0xE2, 0x80, 0x89)
    filename = filename:gsub(thin_space, " ")
    if path and not is_protocol(path) then
        local title = format_filename(filename)
        if title then
            local media_title, season, episode = title:match("^(.-)%s*[sS](%d+)[eE](%d+)")
            if season then
                return media_title
            else
                local media_title, episode = title:match("^(.-)%s*[eE](%d+)")
                if episode then
                    return media_title
                end
            end
            return title
        end

        local directory = get_parent_directory(path)
        local dir, title = utils.split_path(directory:sub(1, -2))
        if title:lower():match("^%s*seasons?%s*%d+%s*$") or title:lower():match("^%s*specials?%s*$") or title:match("^%s*SPs?%s*$")
        or title:match("^%s*O[VAD]+s?%s*$") or title:match("^%s*第.-[季部]+%s*$") then
            directory, title = utils.split_path(dir:sub(1, -2))
        end
        title = title
                :gsub(thin_space, " ")
                :gsub("%[.-%]", "")
                :gsub("^%s*%(%d+.?%d*.?%d*%)", "")
                :gsub("%(%d+.?%d*.?%d*%)%s*$", "")
                :gsub("[%._]", " ")
                :gsub("^%s*(.-)%s*$", "%1")
        return title
    end

    local title = mp.get_property("media-title")
    local media_title, season, episode = nil, nil, nil
    if title then
        title = title:gsub(thin_space, " ")
        local format_title = format_filename(url_decode(title))
        if format_title then
            media_title, season, episode = format_title:match("^(.-)%s*[sS](%d+)[eE](%d+)")
            if season then
                title = media_title
            else
                media_title, episode = format_title:match("^(.-)%s*[eE](%d+)")
                if episode then
                    season = 1
                    title = media_title
                else
                    title = format_title
                end
            end
        end
    end
    if from_menu then
        return title
    end
    return title, season, episode
end

-- 获取当前文件名所包含的集数
function get_episode_number(filename, fname)
    -- 尝试对比记录文件名来获取当前集数
    if fname then
        local episode_num1, episode_num2 = compare_filenames(fname, filename)
        if episode_num1 and episode_num2 then
            return episode_num1, episode_num2
        else
            return nil, nil
        end
    end

    local thin_space = string.char(0xE2, 0x80, 0x89)
    filename = filename:gsub(thin_space, " ")

    local title = format_filename(filename)
    if title then
        local media_title, season, episode = title:match("^(.-)%s*[sS](%d+)[eE](%d+)")
        if season then
            return tonumber(episode)
        else
            local media_title, episode = title:match("^(.-)%s*[eE](%d+)")
            if episode then
                return tonumber(episode)
            end
        end
    end
    return nil
end

-- 写入history.json
-- 读取episodeId获取danmaku
function set_episode_id(input, from_menu)
    from_menu = from_menu or false
    danmaku.source = "dandanplay"
    for url, source in pairs(danmaku.sources) do
        if source.from == "api_server" then
            if source.fname and file_exists(source.fname) then
                os.remove(source.fname)
            end

            if not source.from_history then
                danmaku.sources[url] = nil
            else
                danmaku.sources[url]["fname"] = nil
            end
        end
    end
    local episodeId = tonumber(input)
    if from_menu and options.auto_load or options.autoload_for_url then
        write_history(episodeId)
    end
    set_danmaku_button()
    if options.load_more_danmaku then
        fetch_danmaku_all(episodeId, from_menu)
    else
        fetch_danmaku(episodeId, from_menu)
    end
end

-- 异步执行命令
-- 同时返回 abort 函数，用于取消异步命令
function call_cmd_async(args, callback)
    async_running = true
    local abort_signal = mp.command_native_async({
        name = 'subprocess',
        capture_stderr = true,
        capture_stdout = true,
        playback_only = false,
        args = args,
    }, function(success, result, error)
        if not success or not result or result.status ~= 0 then
            local exit_code = (result and result.status or 'unknown')
            local message = error or (result and result.stdout .. result.stderr) or ''
            callback('Calling failed. Exit code: ' .. exit_code .. ' Error: ' .. message, {})
            return
        end

        local json = result and type(result.stdout) == 'string' and result.stdout or ''
        return callback(nil, json)
    end)

    return function()
        mp.abort_async_command(abort_signal)
    end
end

-- 回退使用额外的弹幕获取方式
function get_danmaku_fallback(query)
    -- 如果是爱奇艺的链接，直接结束加载
    -- 弹幕转换程序无法正确处理爱奇艺的 xml 弹幕
    if query:find("iqiyi%.com") ~= nil then
        show_message("此源弹幕为空，结束加载", 3)
        msg.verbose("此源弹幕为空，结束加载")
        return
    end

    local url = options.fallback_server .. "/?url=" .. query
    msg.verbose("尝试获取弹幕：" .. url)
    local temp_file = "danmaku-" .. pid .. ".xml"
    local danmaku_xml = utils.join_path(danmaku_path, temp_file)
    local arg = {
        "curl",
        "-L",
        "-s",
        "--compressed",
        "--user-agent",
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36 Edg/124.0.0.0",
        "--output",
        danmaku_xml,
        url,
    }

    call_cmd_async(arg, function(error, _)
        async_running = false
        if error then
            show_message("HTTP 请求失败，打开控制台查看详情", 5)
            msg.error(error)
            return
        end
        if file_exists(danmaku_xml) then
            add_danmaku_source_local(danmaku_xml, true)
        end
    end)
end

-- 返回弹幕请求参数
function get_danmaku_args(url)
    local dandanplay_path = utils.join_path(mp.get_script_directory(), "bin")
    if platform == "windows" then
        dandanplay_path = utils.join_path(dandanplay_path, "dandanplay/dandanplay.exe")
    else
        dandanplay_path = utils.join_path(dandanplay_path, "dandanplay/dandanplay")
    end
    local args = {
        dandanplay_path,
        "-X",
        "GET",
        "-H",
        "Accept: application/json",
        "-H",
        "User-Agent: " .. options.user_agent,
        url,
    }

    return args
end

-- 执行哈希匹配获取弹幕
local function match_file(file_path, file_name)
    -- 计算文件哈希
    local file_info = utils.file_info(file_path)
    if file_info and file_info.size < 16 * 1024 * 1024 then
        msg.info("文件小于 16M，无法计算 hash")
        return
    end
    local file, error = io.open(normalize(file_path), 'rb')
    if error ~= nil then
        return msg.error(error)
    end
    local m = md5.new()
    for _ = 1, 16 * 1024 do
        local content = file:read(1024)
        if content == nil then
            file:close()
            return msg.error('无法读取文件内容')
        end
        m:update(content)
    end
    file:close()
    local hash = m:finish()
    if not hash then
        return
    else
        msg.info('hash:', hash)
    end

    local url = options.api_server .. "/api/v2/match"
    local body = utils.format_json({
        fileName = file_name,
        fileHash = hash,
        matchMode = "hashAndFileName"
    })

    local dandanplay_path = utils.join_path(mp.get_script_directory(), "bin")
    if platform == "windows" then
        dandanplay_path = utils.join_path(dandanplay_path, "dandanplay/dandanplay.exe")
    else
        dandanplay_path = utils.join_path(dandanplay_path, "dandanplay/dandanplay")
    end

    local args = {
        dandanplay_path,
        "-X",
        "POST",
        "-H",
        "Content-Type: application/json",
        "-H",
        "Accept: application/json",
        "-H",
        "User-Agent: " .. options.user_agent,
        "-d",
        body,
        url,
    }

    call_cmd_async(args, function(error, json)
        async_running = false
        if error then
            show_message("HTTP 请求失败，打开控制台查看详情", 5)
            msg.error(error)
            return
        end
        local data = utils.parse_json(json)
        if not data or not data.isMatched then
            msg.info("没有匹配的剧集")
            return
        elseif #data.matches > 1 then
            msg.info("找到多个匹配的剧集")
            return
        end

        danmaku.anime = data.matches[1].animeTitle
        danmaku.episode = data.matches[1].episodeTitle

        -- 获取并加载弹幕数据
        set_episode_id(data.matches[1].episodeId, true)
    end)
end

-- 加载弹幕
function load_danmaku(from_menu, no_osd)
    if not enabled then return end
    local temp_file = "danmaku-" .. pid .. ".ass"
    local danmaku_file = utils.join_path(danmaku_path, temp_file)
    local danmaku_input = {}
    local delays = {}

    -- 收集需要加载的弹幕文件
    for _, source in pairs(danmaku.sources) do
        if not source.blocked and source.fname then
            if not file_exists(source.fname) then
                show_message("未找到弹幕文件", 3)
                msg.info("未找到弹幕文件")
                return
            end
            table.insert(danmaku_input, source.fname)

            if source.delay then
                table.insert(delays, source.delay)
            else
                table.insert(delays, "0.0")
            end
        end
    end

    -- 如果没有弹幕文件，退出加载
    if #danmaku_input == 0 then
        show_message("该集弹幕内容为空，结束加载", 3)
        msg.verbose("该集弹幕内容为空，结束加载")
        comments = {}
        return
    end

    -- 异步执行弹幕转换
    convert_with_danmaku_factory(danmaku_input, nil, delays, function(error)
        if error then
            show_message("弹幕转换失败", 3)
            msg.error("弹幕转换失败：" .. error)
            return
        end

        -- 转换完成后加载弹幕
        parse_danmaku(danmaku_file, from_menu, no_osd)
    end)
end

-- 异步获取弹幕数据
function fetch_danmaku_data(args, callback)
    call_cmd_async(args, function(error, json)
        async_running = false
        if error then
            show_message("获取数据失败", 3)
            msg.error("HTTP 请求失败：" .. error)
            return
        end
        local data = utils.parse_json(json)
        callback(data)
    end)
end

-- 保存弹幕数据
function save_danmaku_data(comments, query, danmaku_source)
    local temp_file = "danmaku-" .. pid .. danmaku.count .. ".json"
    local danmaku_file = utils.join_path(danmaku_path, temp_file)
    danmaku.count = danmaku.count + 1
    local success = save_json_for_factory(comments, danmaku_file)

    if success then
        if danmaku.sources[query] ~= nil then
            danmaku.sources[query]["fname"] = danmaku_file
        else
            danmaku.sources[query] = {from = danmaku_source, fname = danmaku_file}
        end
    end
end

-- 处理弹幕数据
function handle_danmaku_data(query, data, from_menu)
    local comments = data["comments"]
    local count = data["count"]

    -- 如果没有数据，进行重试
    if count == 0 then
        show_message("服务器无缓存数据，再次尝试请求", 30)
        msg.verbose("服务器无缓存数据，再次尝试请求")
        -- 等待 2 秒后重试
        local start = os.time()
        while os.time() - start < 2 do
            -- 空循环，等待 2 秒
        end
        -- 重新发起请求
        local url = options.api_server .. "/api/v2/extcomment?url=" .. url_encode(query)
        local args = get_danmaku_args(url)
        fetch_danmaku_data(args, function(retry_data)
            if not retry_data or not retry_data["comments"] then
                get_danmaku_fallback(query)
                return
            end
            save_danmaku_data(retry_data["comments"], query, "user_custom")
            load_danmaku(from_menu)
        end)
    else
        save_danmaku_data(comments, query, "user_custom")
        load_danmaku(from_menu)
    end
end

-- 处理第三方弹幕数据
function handle_related_danmaku(index, relateds, related, shift, callback)
    local url = options.api_server .. "/api/v2/extcomment?url=" .. url_encode(related["url"])
    show_message(string.format("正在从第三方库装填弹幕 [%d/%d]", index, #relateds), 30)
    msg.verbose("正在从第三方库装填弹幕：" .. url)

    local args = get_danmaku_args(url)
    fetch_danmaku_data(args, function(data)
        local comments = {}
        if data and data["comments"] then
            if data["count"] == 0 then
                -- 如果没有数据，稍等 2 秒重试
                local start = os.time()
                while os.time() - start < 2 do
                    -- 空循环，等待 2 秒
                end
                fetch_danmaku_data(args, function(data)
                    for _, comment in ipairs(data["comments"]) do
                        comment["shift"] = shift
                        table.insert(comments, comment)
                    end
                    callback(comments)
                end)
            else
                for _, comment in ipairs(data["comments"]) do
                    comment["shift"] = shift
                    table.insert(comments, comment)
                end
                callback(comments)
            end
        else
            show_message("无数据", 3)
            msg.info("无数据")
        end
    end)
end

-- 处理dandan库的弹幕数据
function handle_main_danmaku(url, from_menu)
    show_message("正在从弹弹Play库装填弹幕", 30)
    msg.verbose("尝试获取弹幕：" .. url)
    local args = get_danmaku_args(url)

    fetch_danmaku_data(args, function(data)
        if not data or not data["comments"] then
            show_message("无数据", 3)
            msg.info("无数据")
            return
        end

        local comments = data["comments"]
        local count = data["count"]

        if count == 0 then
            if danmaku.sources[url] == nil then
                danmaku.sources[url] = {from = "api_server"}
            end
            load_danmaku(from_menu)
            return
        end

        save_danmaku_data(comments, url, "api_server")
        load_danmaku(from_menu)
    end)
end

-- 处理获取到的数据
function handle_fetched_danmaku(data, url, from_menu)
    if data and data["comments"] then
        if data["count"] == 0 then
            if danmaku.sources[url] == nil then
                danmaku.sources[url] = {from = "api_server"}
            end
            show_message("该集弹幕内容为空，结束加载", 3)
            msg.verbose("该集弹幕内容为空，结束加载")
            return
        end
        save_danmaku_data(data["comments"], url, "api_server")
        load_danmaku(from_menu)
    else
        show_message("无数据", 3)
        msg.info("无数据")
    end
end

-- 匹配弹幕库 comment, 仅匹配dandan本身弹幕库
-- 通过danmaku api（url）+id获取弹幕
function fetch_danmaku(episodeId, from_menu)
    local url = options.api_server .. "/api/v2/comment/" .. episodeId .. "?withRelated=true&chConvert=0"
    show_message("弹幕加载中...", 30)
    msg.verbose("尝试获取弹幕：" .. url)
    local args = get_danmaku_args(url)

    fetch_danmaku_data(args, function(data)
        handle_fetched_danmaku(data, url, from_menu)
    end)
end

-- 主函数：获取所有相关弹幕
function fetch_danmaku_all(episodeId, from_menu)
    local url = options.api_server .. "/api/v2/related/" .. episodeId
    show_message("弹幕加载中...", 30)
    msg.verbose("尝试获取弹幕：" .. url)
    local args = get_danmaku_args(url)

    fetch_danmaku_data(args, function(data)
        if not data or not data["relateds"] then
            show_message("无数据", 3)
            msg.info("无数据")
            return
        end

        -- 处理所有的相关弹幕
        local relateds = data["relateds"]
        local function process_related(index)
            if index > #relateds then
                -- 所有相关弹幕加载完成后，开始加载主库弹幕
                url = options.api_server .. "/api/v2/comment/" .. episodeId .. "?withRelated=false&chConvert=0"
                handle_main_danmaku(url, from_menu)
                return
            end

            local related = relateds[index]
            local shift = related["shift"]

            -- 处理当前的相关弹幕
            handle_related_danmaku(index, relateds, related, shift, function(comments)
                if #comments == 0 then
                    if danmaku.sources[related["url"]] == nil then
                        danmaku.sources[related["url"]] = {from = "api_server"}
                    end
                else
                    save_danmaku_data(comments, related["url"], "api_server")
                end

                -- 继续处理下一个相关弹幕
                process_related(index + 1)
            end)
        end

        -- 从第一个相关库开始请求
        process_related(1)
    end)
end

--通过输入源url获取弹幕库
function add_danmaku_source(query, from_menu)
    if danmaku.sources[query] == nil then
        danmaku.sources[query] = {from = "user_custom"}
    end

    from_menu = from_menu or false
    if from_menu then
        add_source_to_history(query, danmaku.sources[query])
    end

    if is_protocol(query) then
        add_danmaku_source_online(query, from_menu)
    else
        add_danmaku_source_local(query, from_menu)
    end
end

function add_danmaku_source_local(query, from_menu)
    local path = normalize(query)
    if not file_exists(path) then
        msg.warn("无效的文件路径")
        return
    end
    if not (string.match(path, "%.xml$") or string.match(path, "%.json$") or string.match(path, "%.ass$")) then
        msg.warn("仅支持弹幕文件")
        return
    end

    if danmaku.sources[query] ~= nil then
        danmaku.sources[query]["from"] = "user_local"
        danmaku.sources[query]["fname"] = path
    else
        danmaku.sources[query] = {from = "user_local", fname = path}
    end

    set_danmaku_button()
    load_danmaku(from_menu)
end

--通过输入源url获取弹幕库
function add_danmaku_source_online(query, from_menu)
    set_danmaku_button()
    local url = options.api_server .. "/api/v2/extcomment?url=" .. url_encode(query)
    show_message("弹幕加载中...", 30)
    msg.verbose("尝试获取弹幕：" .. url)
    local args = get_danmaku_args(url)

    fetch_danmaku_data(args, function(data)
        if not data or not data["comments"] then
            show_message("此源弹幕无法加载", 3)
            msg.verbose("此源弹幕无法加载")
            return
        end
        handle_danmaku_data(query, data, from_menu)
    end)
end

-- 将弹幕转换为factory可读的json格式
function save_json_for_factory(comments, json_filename)
    local temp_file = "danmaku-" .. pid .. ".json"
    json_filename = json_filename or utils.join_path(danmaku_path, temp_file)
    local json_file = io.open(json_filename, "w")

    if json_file then
        json_file:write("[\n")
        for _, comment in ipairs(comments) do
            local p = comment["p"]
            local shift = comment["shift"]
            if p then
                local fields = split(p, ",")
                if shift ~= nil then
                    fields[1] = tonumber(fields[1]) + tonumber(shift)
                end
                local c_value = string.format(
                    "%s,%s,%s,25,,,",
                    tostring(fields[1]), -- first field of p to first field of c
                    fields[3], -- third field of p to second field of c
                    fields[2]  -- second field of p to third field of c
                )
                local m_value = comment["m"]

                -- Write the JSON object as a single line, no spaces or extra formatting
                local json_entry = string.format('{"c":"%s","m":"%s"},\n', c_value, m_value)
                json_file:write(json_entry)
            end
        end
        json_file:write("]")
        json_file:close()
        return true
    end

    return false
end

--将json文件又转换为ass文件。
-- Function to convert JSON file using DanmakuFactory
function convert_with_danmaku_factory(danmaku_input, danmaku_out, delays, callback)
    if exec_path == "" then
        exec_path = utils.join_path(mp.get_script_directory(), "bin/DanmakuFactory")
        if platform == "windows" then
            exec_path = utils.join_path(exec_path, "DanmakuFactory.exe")
        else
            exec_path = utils.join_path(exec_path, "DanmakuFactory")
        end
    end
    local danmaku_factory_path = os.getenv("DANMAKU_FACTORY") or exec_path

    local temp_file = "danmaku-" .. pid .. ".ass"
    local danmaku_file = utils.join_path(danmaku_path, temp_file)

    local arg = {
        danmaku_factory_path,
        "-o",
        danmaku_out and danmaku_out or danmaku_file,
        "-i",
        "-t",
        "--ignore-warnings",
        "--scrolltime", options.scrolltime,
        "--fontname", "sans-serif",
        "--fontsize", options.fontsize,
        "--shadow", options.shadow,
        "--bold", options.bold,
        "--density", options.density,
    --  "--displayarea", options.displayarea,
        "--outline", options.outline,
    }

    local shift = 1

    -- 检查 danmaku_input 是字符串还是数组，并插入到正确的位置
    if type(danmaku_input) == "string" then
        -- 如果是单个字符串，直接插入
        table.insert(arg, 5, danmaku_input)
    else
        -- 如果是字符串数组，逐个插入
        for i, input in ipairs(danmaku_input) do
            table.insert(arg, 4 + i, input)
        end
        shift = #danmaku_input
    end

    if delays then
        for i, delay in ipairs(delays) do
            table.insert(arg, 5 + shift + i, delay)
        end
    else
        table.insert(arg, 6 + shift, "0.0")
    end

    if blacklist_file ~= "" and file_exists(blacklist_file) then
        table.insert(arg, "--blacklist")
        table.insert(arg, blacklist_file)
    end

    if options.blockmode ~= "" then
        table.insert(arg, "--blockmode")
        table.insert(arg, options.blockmode)
    end

    if not callback then
        mp.command_native({
            name = 'subprocess',
            playback_only = false,
            capture_stdout = true,
            args = arg,
        })
    else
        -- 异步执行命令
        call_cmd_async(arg, function(error, _)
            async_running = false
            if callback then
                callback(error)
            end
        end)
    end
end

-- Utility function to split a string by a delimiter
function split(str, delim)
    local result = {}
    for match in (str .. delim):gmatch("(.-)" .. delim) do
        table.insert(result, match)
    end
    return result
end

-- 通过文件前 16M 的 hash 值进行弹幕匹配
function get_danmaku_with_hash(file_name, file_path)
    if is_protocol(file_path) then
        set_danmaku_button()
        local arg = {
            "curl",
            "--range",
            "0-16777215",
            "--user-agent",
            options.user_agent,
            "--output",
            utils.join_path(danmaku_path, "temp-" .. pid .. ".mp4"),
            "-L",
            file_path,
        }

        if options.proxy ~= "" then
            table.insert(arg, '-x')
            table.insert(arg, options.proxy)
        end

        call_cmd_async(arg, function(error, _)
            async_running = false
            if error then
                show_message("HTTP 请求失败，打开控制台查看详情", 5)
                msg.error(error)
                return
            end
            local temp_file = "temp-" .. pid .. ".mp4"
            file_path = utils.join_path(danmaku_path, temp_file)
            if not file_exists(file_path) then
                return
            end

            match_file(file_path, file_name)
        end)
    else
        match_file(file_path, file_name)
    end
end

-- 从用户添加过的弹幕源添加弹幕
function addon_danmaku(from_menu)
    for url, source in pairs(danmaku.sources) do
        if source.from ~= "api_server" then
            add_danmaku_source(url, from_menu)
        end
    end
end

function remove_source_from_history(rm_source)
    local history_json = read_file(history_path)
    local path = mp.get_property("path")

    if history_json then
        local history = utils.parse_json(history_json) or {}

        if history[path] ~= nil then
            for i, source in ipairs(history[path]) do
                source = source:gsub("^-", ""):gsub("^<.->", ""):gsub("^{{.-}}", "")
                if source == rm_source then
                    table.remove(history[path], i)
                    break
                end
            end
        end

        write_json_file(history_path, history)
    end
end

function add_source_to_history(add_url, add_source)
    local history_json = read_file(history_path)
    local path = mp.get_property("path")

    if is_protocol(path) then
        path = remove_query(path)
    end

    if history_json then
        local history = utils.parse_json(history_json) or {}
        history[path] = history[path] or {}

        for i, source in ipairs(history[path]) do
            source = source:gsub("^-", ""):gsub("^<.->", ""):gsub("^{{.-}}", "")
            if source == add_url then
                table.remove(history[path], i)
                break
            end
        end

        if add_source.delay then
            add_url = "{{" .. add_source.delay .. "}}" .. add_url
        end

        if add_source.from then
            add_url = "<" .. add_source.from .. ">" .. add_url
        end

        if add_source.blocked then
            add_url = "-" .. add_url
        end

        table.insert(history[path], add_url)

        write_json_file(history_path, history)
    end
end

function read_danmaku_source_record(path)
    if is_protocol(path) then
        path = remove_query(path)
    end

    local history_json = read_file(history_path)

    if history_json ~= nil then
        local history = utils.parse_json(history_json) or {}
        local history_record = history[path]
        if history_record ~= nil then
            for _, source in ipairs(history_record) do
                local blocked = false
                local from = string.match(source,"<(.-)>")
                local delay = string.match(source,"{{(.-)}}")
                if source:match("^-") then
                    source = source:sub(2)
                    blocked = true
                    from = "api_server"
                end
                if from then
                    source = source:gsub("<" .. from .. ">", "")
                end
                if delay then
                    source = source:gsub("{{" .. delay .. "}}", "")
                end

                danmaku.sources[source] = {}

                if blocked then
                    danmaku.sources[source]["blocked"] = true
                end

                danmaku.sources[source]["from"] = from or "user_custom"

                if delay then
                    danmaku.sources[source]["delay"] = delay
                end

                danmaku.sources[source]["from_history"] = true
            end
        end
    end

end

-- 为 bilibli 网站的视频播放加载弹幕
function load_danmaku_for_bilibili(path)
    local cid, danmaku_id = get_cid()
    if danmaku_id ~= nil then
        mp.commandv('sub-remove', danmaku_id)
    end

    if cid == nil then
        cid = mp.get_opt('cid')
        if not cid then
            local patterns = {
                "bilivideo%.c[nom]+.*/resource/(%d+)%D+.*",
                "bilivideo%.c[nom]+.*/(%d+)-%d+-%d+%..*%?",
            }
            local urls = {
                path,
                mp.get_property("stream-open-filename", ''),
            }

            for _, pattern in ipairs(patterns) do
                for _, url in ipairs(urls) do
                    if url:find(pattern) then
                        cid = url:match(pattern)
                        break
                    end
                end
            end
        end
    end
    if cid == nil and path:match("/video/BV.-") then
        if path:match("video/BV.-/.*") then
            path = path:gsub("/[^/]+$", "")
        end
        add_danmaku_source_online(path, true)
        return
    end
    if cid ~= nil then
        local url = "https://comment.bilibili.com/" .. cid .. ".xml"
        local temp_file = "danmaku-" .. pid .. ".xml"
        local danmaku_xml = utils.join_path(danmaku_path, temp_file)
        local arg = {
            "curl",
            "-L",
            "-s",
            "--compressed",
            "--user-agent",
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36 Edg/124.0.0.0",
            "--output",
            danmaku_xml,
            url,
        }

        call_cmd_async(arg, function(error, _)
            async_running = false
            if error then
                show_message("HTTP 请求失败，打开控制台查看详情", 5)
                msg.error(error)
                return
            end
            if file_exists(danmaku_xml) then
                add_danmaku_source_local(danmaku_xml, true)
            end
        end)
    end
end

-- 为 bahamut 网站的视频播放加载弹幕
function load_danmaku_for_bahamut(path)
    local path = path:gsub('%%(%x%x)', hex_to_char)
    local sn = extract_between_colons(path)
    if sn == nil then
        return
    end
    local url = "https://ani.gamer.com.tw/ajax/danmuGet.php"
    local temp_file = "bahamut-" .. pid .. ".json"
    local danmaku_json = utils.join_path(danmaku_path, temp_file)
    local arg = {
        "curl",
        "-X",
        "POST",
        "-d",
        "sn=" .. sn,
        "-L",
        "-s",
        "--user-agent",
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/85.0.4183.83 Safari/537.36",
        "--header",
        "Origin: https://ani.gamer.com.tw",
        "--header",
        "Content-Type: application/x-www-form-urlencoded;charset=utf-8",
        "--header",
        "Accept: application/json",
        "--header",
        "Authority: ani.gamer.com.tw",
        "--output",
        danmaku_json,
        url,
    }

    if options.proxy ~= "" then
        table.insert(arg, '-x')
        table.insert(arg, options.proxy)
    end

    call_cmd_async(arg, function(error, _)
        async_running = false
        if error then
            show_message("HTTP 请求失败，打开控制台查看详情", 5)
            msg.error(error)
            return
        end
        if not file_exists(danmaku_json) then
            url = "https://ani.gamer.com.tw/animeVideo.php?sn=" .. sn
            enabled = true
            add_danmaku_source_online(url, true)
            return
        end

        local comments_json = read_file(danmaku_json)
        local comments = utils.parse_json(comments_json)
        if not comments then
            return
        end

        local temp_file = "danmaku-" .. pid .. ".json"
        local json_filename = utils.join_path(danmaku_path, temp_file)
        local json_file = io.open(json_filename, "w")

        if json_file then
            json_file:write("[\n")
            for _, comment in ipairs(comments) do
                local m = comment["text"]
                local color = hex_to_int_color(comment["color"])
                local mode = get_type_from_position(comment["position"])
                local time = tonumber(comment["time"]) / 10
                local c = time .. "," .. color .. "," .. mode .. ",25,,,"

                -- Write the JSON object as a single line, no spaces or extra formatting
                local json_entry = string.format('{"c":"%s","m":"%s"},\n', c, m)
                json_file:write(json_entry)
            end
            json_file:write("]")
            json_file:close()
        end

        if danmaku.sources[url] ~= nil then
            danmaku.sources[url]["fname"] = json_filename
        else
            danmaku.sources[url] = {from = "user_custom", fname = json_filename}
        end
        load_danmaku(true)
    end)
end

function load_danmaku_for_url(path)
    if path:find('bilibili.com') or path:find('bilivideo.c[nom]+') then
        load_danmaku_for_bilibili(path)
        return
    end

    if path:find('bahamut.akamaized.net') then
        load_danmaku_for_bahamut(path)
        return
    end

    local title, season_num, episod_num = parse_title()
    local filename = url_decode(mp.get_property("media-title"))
    local episod_number = nil
    if title and episod_num then
        if season_num then
            dir = title .." Season".. season_num
            episod_number = episod_num
        else
            dir = title
        end
        auto_load_danmaku(path, dir, filename, episod_number)
        addon_danmaku()
        return
    end
    get_danmaku_with_hash(filename, path)
    addon_danmaku()
end

-- 自动加载上次匹配的弹幕
function auto_load_danmaku(path, dir, filename, number)
    if dir ~= nil then
        local history_json = read_file(history_path)
        if history_json ~= nil then
            local history = utils.parse_json(history_json) or {}
            -- 1.判断父文件名是否存在
            local history_dir = history[dir]
            if history_dir ~= nil then
                --2.如果存在，则获取number和id
                danmaku.anime = history_dir.animeTitle
                local episode_number = history_dir.episodeTitle and history_dir.episodeTitle:match("%d+")
                local history_number = history_dir.episodeNumber
                local history_id = history_dir.episodeId
                local history_fname = history_dir.fname
                local history_extra = history_dir.extra
                local playing_number = nil

                if history_fname then
                    if filename ~= history_fname then
                        if number then
                            playing_number = number
                        else
                            history_number, playing_number = get_episode_number(filename, history_fname)
                        end
                    else
                        playing_number = history_number
                    end
                else
                    playing_number = get_episode_number(filename)
                end
                if playing_number ~= nil then
                    local x = playing_number - history_number --获取集数差值
                    danmaku.episode = episode_number and string.format("第%s话", episode_number + x) or history_dir.episodeTitle
                    show_message("自动加载上次匹配的弹幕", 3)
                    msg.verbose("自动加载上次匹配的弹幕")
                    if history_id then
                        local tmp_id = tostring(x + history_id)
                        set_episode_id(tmp_id)
                    elseif history_extra then
                        local episodenum = history_extra.episodenum + x
                        get_details(history_extra.class, history_extra.id, history_extra.site,
                            history_extra.title, history_extra.year, history_extra.number, episodenum)
                    end
                else
                    get_danmaku_with_hash(filename, path)
                end
            else
                get_danmaku_with_hash(filename, path)
            end
        else
            get_danmaku_with_hash(filename, path)
        end
    end
end

function init(path)
    if not path then return end
    local dir = get_parent_directory(path)
    local filename = mp.get_property('filename/no-ext')
    local video = mp.get_property_native("current-tracks/video")
    local fps = mp.get_property_number("container-fps", 0)
    local duration = mp.get_property_number("duration", 0)
    if not video or video["image"] or video["albumart"] or fps < 23 or duration < 60 then
        msg.info("不支持的播放内容（非视频）")
        return
    end
    if is_protocol(path) then
        load_danmaku_for_url(path)
    end
    if dir and filename then
        local danmaku_xml = utils.join_path(dir, filename .. ".xml")
        if file_exists(danmaku_xml) then
            add_danmaku_source_local(danmaku_xml, true)
        else
            auto_load_danmaku(path, dir, filename)
            addon_danmaku(true)
        end
    end
end

mp.add_key_binding(options.open_search_danmaku_menu_key, "open_search_danmaku_menu", function ()
    mp.commandv("script-message", "open_search_danmaku_menu")
end)
mp.add_key_binding(options.show_danmaku_keyboard_key, "show_danmaku_keyboard", function ()
    mp.commandv("script-message", "show_danmaku_keyboard")
end)

mp.register_script_message("clear-source", function ()
    local path = mp.get_property("path")
    local history_json = read_file(history_path)

    if history_json ~= nil then
        local history = utils.parse_json(history_json) or {}
        if path and history[path] ~= nil then
            history[path] = nil
            write_json_file(history_path, history)
            for url, source in pairs(danmaku.sources) do
                if source.from == "user_custom" then
                    if source.fname and file_exists(source.fname) then
                        os.remove(source.fname)
                    end
                    danmaku.sources[url] = nil
                end
            end
            load_danmaku(false)
            show_message("已重置当前视频所有弹幕源更改", 3)
            msg.verbose("已重置当前视频所有弹幕源更改")
        end
    end
end)

mp.register_event("file-loaded", function()
    local path = mp.get_property("path")
    local dir = get_parent_directory(path)
    local filename = mp.get_property('filename/no-ext')
    local video = mp.get_property_native("current-tracks/video")
    local fps = mp.get_property_number("container-fps", 0)
    local duration = mp.get_property_number("duration", 0)
    if not video or video["image"] or video["albumart"] or fps < 23 or duration < 60 then
        return
    end

    read_danmaku_source_record(path)

    if not get_danmaku_visibility() then
        return
    end

    if options.autoload_for_url and is_protocol(path) then
        enabled = true
        load_danmaku_for_url(path)
    end

    if filename == nil or dir == nil then
        return
    end
    local danmaku_xml = utils.join_path(dir, filename .. ".xml")
    if options.autoload_local_danmaku then
        if file_exists(danmaku_xml) then
            enabled = true
            add_danmaku_source_local(danmaku_xml)
            return
        end
    end

    if options.auto_load then
        enabled = true
        auto_load_danmaku(path, dir, filename)
        addon_danmaku()
        return
    end

    if enabled and comments == nil and not async_running then
        init(path)
    end
end)
