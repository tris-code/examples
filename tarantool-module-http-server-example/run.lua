#!/usr/bin/env tarantool

local moduleName = 'example'
package.cpath =
    '.build/debug/lib'..moduleName..'.so;.build/debug/lib'..moduleName..'.dylib;'..
    '.build/release/lib'..moduleName..'.so;.build/release/lib'..moduleName..'.dylib;'..
    package.cpath

local ffi = require('ffi')
local fiber = require('fiber')

local lib = ffi.load(package.searchpath(moduleName, package.cpath))
ffi.cdef[[int entry_point();]]

os.execute("mkdir -p data")

box.cfg {
    snap_dir = "data",
    wal_dir = "data",
    slab_alloc_arena=0.2
}

local space = box.space.data
if not space then
    space = box.schema.create_space('data')
    space:create_index('primary', { parts = {1, 'STR'} })
end

lib.entry_point()

require('console').start()
