--[[
    The MIT License (MIT)

    Copyright (c) 2014 Danila Poyarkov <dannotemail@gmail.com>

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.
]]

local template = {}

function template.escape(data)
    return tostring(data or ''):gsub("[\">/<'&]", {
        ["&"] = "&amp;",
        ["<"] = "&lt;",
        [">"] = "&gt;",
        ['"'] = "&quot;",
        ["'"] = "&#39;",
        ["/"] = "&#47;"
    })
end

function template.print(data, args, callback)
    callback = callback or print
    local function exec(inner_data)
        if type(inner_data) == "function" then
            local inner_args = args or {}
            setmetatable(inner_args, { __index = _G })
            setfenv(inner_data, inner_args)
            inner_data(exec)
        else
            callback(tostring(inner_data or ''))
        end
    end
    exec(data)
end

function template.parse(data, minify)
    local str =
        "return function(_)" ..
        "function __(...)" ..
        "_(require('template').escape(...))" ..
        "end " ..
        "_[=[" ..
        data:
        gsub("[][]=[][]", ']=]_"%1"_[=['):
        gsub("<%%=", "]=]_("):
        gsub("<%%", "]=]__("):
        gsub("%%>", ")_[=["):
        gsub("<%?", "]=] "):
        gsub("%?>", " _[=[") ..
        "]=] " ..
        "end"
    if minify then
        str = str:
        gsub("^[ %s]*", ""):
        gsub("[ %s]*$", ""):
        gsub("%s+", " ")
    end
    return str
end

function template.compile(...)
    return loadstring(template.parse(...))()
end

return template
