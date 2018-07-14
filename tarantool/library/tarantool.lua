#!/usr/bin/env tarantool

local swift_module_name = 'swift_tarantool_module'

-- module search paths for box.schema.func.create
package.cpath =
    'lib'..swift_module_name..'.dylib;'..
    '.build/x86_64-apple-macosx10.10/debug/lib'..swift_module_name..'.so;.build/x86_64-apple-macosx10.10/debug/lib'..swift_module_name..'.dylib;'..
    '.build/x86_64-unknown-linux/release/lib'..swift_module_name..'.so;.build/x86_64-unknown-linux/release/lib'..swift_module_name..'.dylib;'..
    package.cpath

os.execute("mkdir -p data")

-- init tarantool
box.cfg {
    listen = 3301,
    log='data/tarantool.log',
    wal_dir = "data",
    memtx_dir = "data",
    vinyl_dir = "data",
    memtx_memory=209715200 -- limit memory to 200mb to run on cheap virtual servers
}

-- create data space
local data = box.schema.create_space('data', {if_not_exists = true})
-- create primary index, type: tree, field type: string
data:create_index('primary', { parts = {1, 'STR'}, if_not_exists = true})

-- init swift module
swift = require(swift_module_name)

swift.exported1()
swift.exported2()

-- 1. native way
box.schema.func.create('hello_swift_native', {language = "C", if_not_exists = true})
box.schema.func.create('get_foo_native', {language = "C", if_not_exists = true})
box.schema.func.create('get_count_native', {language = "C", if_not_exists = true})
box.schema.func.create('eval_lua_native', {language = "C", if_not_exists = true})

-- guest user rights
box.schema.user.grant('guest', 'read,write,execute', 'universe', nil, {if_not_exists = true})

-- test space for getCount function
local test = box.schema.space.create('test', {if_not_exists = true})
test:create_index('primary', {type = 'tree', parts = {1, 'unsigned'}, if_not_exists = true})

test:replace({1, 'foo'})
test:replace({2, 'bar'})
test:replace({3, 'baz'})

-- test lua call
box.schema.func.create('test_lua', {if_not_exists = true})
function test_lua()
    local result = {}
    local count = 0
    local search_key = 2

    for _,tuple in box.space['test'].index[0]:pairs(search_key,{iterator = box.index.GE}) do
        count = count + 1
        result[count] = tuple
    end

    return result
end

-- enable console if needed
require('console').start()
