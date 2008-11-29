local json = require("json")

local function test_array()
    local arr = json.array()
    assert(type(arr) == "table")
    assert(arr[json.tag] == json.array)

    local arr_2 = {1, 3, 8}
    local arr_3 = json.array(arr_2)
    assert(arr_2 == arr_3)
    assert(arr_2[json.tag] == json.array)
end

local function test_decode_string()
    assert(json.decode("\"\"") == "")
    assert(json.decode("\"The Dude abides.\"") == "The Dude abides.")
    assert(json.decode("\"\\\"\\\\\\/\"") == "\"\\/")
    assert(json.decode("\"\\b\\f\\n\\r\\t\"") == "\b\f\n\r\t")
end

local function test_decode_number()
    assert(json.decode("0") == 0)
    assert(json.decode("42") == 42)
end

local function test_decode_object()
end

local function test_decode_array()
    local arr = json.decode("[]")
    assert(type(arr) == "table")
    assert(#arr == 0)
end

local function test_decode_true()
    assert(json.decode("true") == true)
end

local function test_decode_false()
    assert(json.decode("false") == false)
end

local function test_decode_null()
    assert(json.decode("null") == json.null)
end

local function test_null()
    assert(json.null() == json.null)
end

local function test_object()
    local obj = json.object()
    assert(type(obj) == "table")
    assert(obj[json.tag] == json.object)

    local obj_2 = {the = 1, dude = 3, abides = 8}
    local obj_3 = json.object(obj_2)
    assert(obj_2 == obj_3)
    assert(obj_2[json.tag] == json.object)
end

local function test_skip_comment()
    assert(json.decode("13 // thirteen") == 13)
    assert(json.decode("// thirteen\n13") == 13)

    assert(json.decode("/* forty */ 42 /* two */") == 42)
    assert(json.decode([[
                         /*
                          * forty-two
                          */
                         42
                       ]]) == 42)
end

local function test()
    test_array()
    test_decode_array()
    test_decode_false()
    test_decode_null()
    test_decode_number()
    test_decode_object()
    test_decode_string()
    test_decode_true()
    test_null()
    test_object()
    test_skip_comment()
end

test()
