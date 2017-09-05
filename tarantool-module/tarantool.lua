#!/usr/bin/env tarantool

local swift_module_name = 'SwiftTarantoolModule'
package.cpath =
    '.build/debug/lib'..swift_module_name..'.so;.build/debug/lib'..swift_module_name..'.dylib;'..
    '.build/release/lib'..swift_module_name..'.so;.build/release/lib'..swift_module_name..'.dylib;'..
    package.cpath

os.execute("mkdir -p data")

-- init tarantool
box.cfg {
    listen = 3301,
    snap_dir = "data",
    wal_dir = "data",
    vinyl_dir = "data",
    slab_alloc_arena=0.2 -- limit memory to 200mb to run on cheap vps/vds
}

-- init swift module
local swift = require(swift_module_name)

print(swift.func1())
print(swift.func2())

-- create data space
local data = box.schema.create_space('data', {if_not_exists = true})
data:create_index('primary', { parts = {1, 'STR'}, if_not_exists = true})

-- hello from lua
box.schema.func.create('helloLua', {if_not_exists = true})
function helloLua()
    return 'hello from lua'
end
-- hello from swift
box.schema.func.create('helloSwift', {language = "C", if_not_exists = true})
box.schema.func.create('getFoo', {language = "C", if_not_exists = true})
box.schema.func.create('getCount', {language = "C", if_not_exists = true})
box.schema.func.create('evalLuaScript', {language = "C", if_not_exists = true})

-- guest user rights
box.schema.user.grant('guest', 'read,write,execute', 'universe', nil, {if_not_exists = true})

-- test space for getCount function
local test = box.schema.space.create('test', {if_not_exists = true})
test:create_index('primary', {type = 'hash', parts = {1, 'unsigned'}, if_not_exists = true})

test:replace({1, 'foo'})
test:replace({2, 'bar'})
test:replace({3, 'baz'})

-- enable console if needed
-- require('console').start()
