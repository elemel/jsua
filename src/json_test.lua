local json = require("json")

local function test_read_array()
    local arr = json.read("[]")
    assert(type(arr) == "table")
    assert(json.Array and getmetatable(arr) == json.Array)
    assert(#arr == 0)

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
    assert(type(obj) == "table")
    assert(json.Object and getmetatable(obj) == json.Object)
    assert(#obj == 0)
    
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
