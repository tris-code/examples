#!/usr/bin/env tarantool

os.execute("mkdir -p data")

box.cfg {
    listen = 3301,
    log='data/tarantool.log',
    wal_dir = "data",
    memtx_dir = "data",
    vinyl_dir = "data",
    memtx_memory=209715200 -- limit memory to 200mb to run on cheap virtual servers
}

box.schema.user.passwd('admin', 'admin')

print("started")
