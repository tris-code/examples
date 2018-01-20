#!/usr/bin/env tarantool

local moduleName = 'module'
package.cpath =
    '.build/debug/lib'..moduleName..'.so;.build/debug/lib'..moduleName..'.dylib;'..
    '.build/release/lib'..moduleName..'.so;.build/release/lib'..moduleName..'.dylib;'..
    package.cpath

local ffi = require('ffi')
local fiber = require('fiber')

--init swift module
local lib = ffi.load(package.searchpath(moduleName, package.cpath))
ffi.cdef[[void tarantool_module_init();]]
lib.tarantool_module_init()

ffi.cdef[[int entry_point();]]

os.execute("mkdir -p data")

box.cfg {
    snap_dir = "data",
    wal_dir = "data",
    vinyl_dir = "data",
    slab_alloc_arena=0.2
}

local space = box.schema.create_space('data', {if_not_exists = true})
space:create_index('primary', { parts = {1, 'STR'}, if_not_exists = true })

lib.entry_point()

-- enable console if needed
-- require('console').start()
