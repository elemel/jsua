-- Copyright (c) 2008 Mikael Lind
-- 
-- Permission is hereby granted, free of charge, to any person
-- obtaining a copy of this software and associated documentation
-- files (the "Software"), to deal in the Software without
-- restriction, including without limitation the rights to use,
-- copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the
-- Software is furnished to do so, subject to the following
-- conditions:
-- 
-- The above copyright notice and this permission notice shall be
-- included in all copies or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
-- EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
-- OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
-- NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
-- HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
-- WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
-- FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
-- OTHER DEALINGS IN THE SOFTWARE.

local json = {}

json.Object = {}
json.Array = {}

local impl = {}

local escapes = {["\""] = "\"", ["\\"] = "\\", ["/"] = "/", b = "\b",
                 f = "\f", n = "\n", r = "\r", t = "\t"}

local number_chars = "-0123456789.eE"
local whitespace_chars = " \n\r\t"

function is_substring(sub, str)
    return string.find(str, sub, 1, true) ~= nil
end

function impl.is_number_char(char)
    return is_substring(char, number_chars)
end

function impl.is_whitespace_char(char)
    return is_substring(char, whitespace_chars)
end

function impl.decode(str, pos)
    local char = string.sub(str, pos, pos)
    if char == "\"" then
        return impl.decode_string(str, pos)
    elseif impl.is_number_char(char) then
        return impl.decode_number(str, pos)
    elseif char == "{" then
        return impl.decode_object(str, pos)
    elseif char == "[" then
        return impl.decode_array(str, pos)
    elseif char == "t" then
        return impl.decode_value(str, pos, "true", true)
    elseif char == "f" then
        return impl.decode_value(str, pos, "false", false)
    elseif char == "n" then
        return impl.decode_value(str, pos, "null", json.null)
    else
        impl.decode_error(str, pos)
    end
end

function impl.skip_whitespace(str, pos)
    local len = #str
    while pos <= len do
        local char = string.sub(str, pos, pos)
        if char == "/" then
            pos = impl.skip_comment(str, pos)
        elseif impl.is_whitespace_char(char) then
            pos = pos + 1
        else
            break
        end
    end
    return pos
end

function impl.skip_comment(str, pos)
    local char = string.sub(str, pos + 1, pos + 1)
    if char == "/" then
        return (string.find(str, "\n", pos + 2, true) or #str) + 1
    elseif char == "*" then
        return string.find(str, "*/", pos + 2, true) + 2
    else
        impl.decode_error(str, pos)
    end
end

function impl.decode_string(str, pos)
    local buffer = {}
    while true do
        pos = pos + 1
        local char = string.sub(str, pos, pos)
        if char == "" then
            error("EOF in JSON string")
        elseif char == "\"" then
            break
        elseif char == "\\" then
            pos = pos + 1
            char = string.sub(str, pos, pos)
            if escapes[char] then
                table.insert(buffer, escapes[char])
            elseif char == "u" then
                error("JSON unicode escapes are not supported")
            else
                impl.decode_error(str, pos)
            end
        else
            table.insert(buffer, char)
        end
    end
    return table.concat(buffer, ""), pos + 1
end

function impl.decode_number(str, pos)
    local stop = pos + 1
    while stop <= #str and impl.is_number_char(string.sub(str, stop, stop))  do
        stop = stop + 1
    end
    return tonumber(string.sub(str, pos, stop - 1)), stop
end

function impl.decode_object(str, pos)
    local obj = {}
    return obj, pos + 2
end

function impl.decode_array(str, pos)
    local arr = {}
    return arr, pos + 2
end

function impl.decode_value(str, pos, pattern, value)
    if string.sub(str, pos, pos + #pattern - 1) ~= pattern then
        impl.decode_error(str, pos)
    end
    return value, pos + #pattern
end

function impl.decode_error(str, pos)
    error("JSON decode error at position " .. pos)
end

function json.array(arr)
    arr = arr or {}
    arr[json.tag] = json.array
    return arr
end

function json.decode(str)
    local pos = impl.skip_whitespace(str, 1)
    local value, pos = impl.decode(str, pos)
    local pos = impl.skip_whitespace(str, pos)
    if pos <= #str then
        impl.decode_error(str, pos)
    end
    return value
end

function json.encode(val)
    local buffer = {}
    impl.encode(val, buffer)
    return table.concat(buffer, "")
end

function json.null()
    return json.null
end

function json.object(obj)
    obj = obj or {}
    obj[json.tag] = json.object
    return obj
end

function json.tag(val)
    if type(val) == "table" then
        return val[json.tag]
    else
        return nil
    end
end

return json
