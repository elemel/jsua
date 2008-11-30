local json = require("json")

local function test_parse_array()
    local arr = json.parse("[]")
    assert(type(arr) == "table")
    assert(json.Array and getmetatable(arr) == json.Array)
    assert(#arr == 0)

    local arr = json.parse("[2,3,5]")
    assert(#arr == 3)
    assert(arr[1] == 2)
    assert(arr[2] == 3)
    assert(arr[3] == 5)
end

local function test_parse_string()
    assert(json.parse("\"\"") == "")
    assert(json.parse("\"The Dude abides.\"") == "The Dude abides.")
    assert(json.parse("\"\\\"\\\\\\/\"") == "\"\\/")
    assert(json.parse("\"\\b\\f\\n\\r\\t\"") == "\b\f\n\r\t")
end

local function test_parse_number()
    assert(json.parse("0") == 0)
    assert(json.parse("42") == 42)
end

local function test_parse_object()
    local obj = json.parse("{}")
    assert(type(obj) == "table")
    assert(json.Object and getmetatable(obj) == json.Object)
    assert(#obj == 0)
    
    local obj = json.parse('{"the":true,"dude":false,"abides":null}')
    assert(obj.the == true)
    assert(obj.dude == false)
    assert(obj.abides == json.null)
end

local function test_parse_true()
    assert(json.parse("true") == true)
end

local function test_parse_false()
    assert(json.parse("false") == false)
end

local function test_parse_null()
    assert(json.null and json.parse("null") == json.null)
end

local function test_skip_comment()
    assert(json.parse("13 // thirteen") == 13)
    assert(json.parse("// thirteen\n13") == 13)

    assert(json.parse("/* forty */ 42 /* two */") == 42)
    assert(json.parse([[
                         /*
                          * forty-two
                          */
                         42
                       ]]) == 42)
end

local function test()
    test_parse_array()
    test_parse_false()
    test_parse_null()
    test_parse_number()
    test_parse_object()
    test_parse_string()
    test_parse_true()
    test_skip_comment()
end

test()
