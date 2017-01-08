#!/usr/bin/env tarantool

local moduleName = 'Module'
package.cpath =
    '.build/debug/lib'..moduleName..'.so;.build/debug/lib'..moduleName..'.dylib;'..
    '.build/release/lib'..moduleName..'.so;.build/release/lib'..moduleName..'.dylib;'..
    package.cpath

os.execute("mkdir -p data")

box.cfg {
    listen = 3301,
    snap_dir = "data",
    wal_dir = "data",
    slab_alloc_arena=0.2 -- limit memory to 200mb to run on cheap vps/vds
}

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
-- test swift stored procedure
box.schema.func.create('getFoo', {language = "C", if_not_exists = true})

-- guest user rights
box.schema.user.grant('guest', 'read,write,execute', 'universe', nil, {if_not_exists = true})
box.schema.user.grant('guest', 'execute', 'function', 'helloLua', {if_not_exists = true})
box.schema.user.grant('guest', 'execute', 'function', 'helloSwift', {if_not_exists = true})
box.schema.user.grant('guest', 'execute', 'function', 'getFoo', {if_not_exists = true})
