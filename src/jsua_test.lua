local jsua = require("jsua")

local function test_read_array()
    local arr = jsua.read("[]")
    assert(jsua.is_array(arr))

    local arr = jsua.read("[2,3,5]")
    assert(#arr == 3)
    assert(arr[1] == 2)
    assert(arr[2] == 3)
    assert(arr[3] == 5)
end

local function test_read_constant()
    assert(jsua.read("true") == true)
    assert(jsua.read("false") == false)
    assert(jsua.read("null") == jsua.null)
end

local function test_read_number()
    assert(jsua.read("0") == 0)
    assert(jsua.read("42") == 42)
end

local function test_read_object()
    local obj = jsua.read("{}")
    assert(jsua.is_object(obj))
    
    local obj = jsua.read('{"the":true,"dude":false,"abides":null}')
    assert(obj.the == true)
    assert(obj.dude == false)
    assert(obj.abides == jsua.null)
end

local function test_read_string()
    assert(jsua.read("\"\"") == "")
    assert(jsua.read("\"The Dude abides.\"") == "The Dude abides.")
    assert(jsua.read("\"\\\"\\\\\\/\"") == "\"\\/")
    assert(jsua.read("\"\\b\\f\\n\\r\\t\"") == "\b\f\n\r\t")
end

local function test_skip_comment()
    assert(jsua.read("13 // thirteen") == 13)
    assert(jsua.read("// thirteen\n13") == 13)

    assert(jsua.read("/* forty */ 42 /* two */") == 42)
    assert(jsua.read([[
                         /*
                          * forty-two
                          */
                         42
                       ]]) == 42)
end

local function test_write_array()
    assert(jsua.write({2, 3, 5}) == "[2, 3, 5]")
end

local function test_write_constant()
    assert(jsua.write(true) == "true")
    assert(jsua.write(false) == "false")
    assert(jsua.write(nil) == "null")
    assert(jsua.write(jsua.null) == "null")
end

local function test_write_number()
    assert(jsua.write(0) == "0")
    assert(jsua.write(-1) == "-1")
    assert(jsua.write(42) == "42")
    assert(jsua.write(3.14) == "3.14")
end

local function test_write_object()
    assert(jsua.write({the = 2, dude = 3, abides = 5}) ==
           '{"abides": 5, "dude": 3, "the": 2}')
end

local function test_write_string()
    assert(jsua.write("The Dude abides.") == '"The Dude abides."')
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
