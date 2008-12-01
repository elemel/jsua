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

local json = require("json")

local function test_read_array()
    local arr = json.read("[]")
    assert(json.is_array(arr))

    local arr = json.read("[2,3,5]")
    assert(#arr == 3)
    assert(arr[1] == 2)
    assert(arr[2] == 3)
    assert(arr[3] == 5)
end

local function test_read_constant()
    assert(json.read("true") == true)
    assert(json.read("false") == false)
    assert(json.null and json.read("null") == json.null)
end

local function test_read_number()
    assert(json.read("0") == 0)
    assert(json.read("42") == 42)
end

local function test_read_object()
    local obj = json.read("{}")
    assert(json.is_object(obj))
    
    local obj = json.read('{"the":true,"dude":false,"abides":null}')
    assert(obj.the == true)
    assert(obj.dude == false)
    assert(obj.abides == json.null)
end

local function test_read_string()
    assert(json.read("\"\"") == "")
    assert(json.read("\"The Dude abides.\"") == "The Dude abides.")
    assert(json.read("\"\\\"\\\\\\/\"") == "\"\\/")
    assert(json.read("\"\\b\\f\\n\\r\\t\"") == "\b\f\n\r\t")
end

local function test_skip_comment()
    assert(json.read("13 // thirteen") == 13)
    assert(json.read("// thirteen\n13") == 13)

    assert(json.read("/* forty */ 42 /* two */") == 42)
    assert(json.read([[
                         /*
                          * forty-two
                          */
                         42
                       ]]) == 42)
end

local function test_write_array()
    assert(json.write({2, 3, 5}) == "[2, 3, 5]")
end

local function test_write_constant()
    assert(json.write(true) == "true")
    assert(json.write(false) == "false")
    assert(json.write(nil) == "null")
    assert(json.write(json.null) == "null")
end

local function test_write_number()
    assert(json.write(0) == "0")
    assert(json.write(-1) == "-1")
    assert(json.write(42) == "42")
    assert(json.write(3.14) == "3.14")
end

local function test_write_object()
    assert(json.write({the = 2, dude = 3, abides = 5}) ==
           '{"abides": 5, "dude": 3, "the": 2}')
end

local function test_write_string()
    assert(json.write("The Dude abides.") == '"The Dude abides."')
end

local function test()
    test_read_array()
    test_read_constant()
    test_read_number()
    test_read_object()
    test_read_string()
    test_skip_comment()
    test_write_array()
    test_write_constant()
    test_write_number()
    test_write_object()
    test_write_string()
end

test()
