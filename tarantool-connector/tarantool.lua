#!/usr/bin/env tarantool

os.execute("mkdir -p data")

box.cfg {
    listen = 3301,
    snap_dir = "data",
    wal_dir = "data",
    vinyl_dir = "data",
    slab_alloc_arena=0.2
}

box.schema.user.passwd('admin', 'admin')

local test = box.schema.space.create('test', {if_not_exists = true})
test:create_index('primary', {type = 'tree', parts = {1, 'unsigned'}, if_not_exists = true})

if not box.schema.user.exists('tester') then
    box.schema.user.create('tester', { password = 'tester' })
    box.schema.user.grant('tester', 'read,write,eval,execute', 'universe')
end

test:replace({1, 'foo'})
test:replace({2, 'bar'})
test:replace({3, 'baz'})
