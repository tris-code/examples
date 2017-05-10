
// called by require('ModuleExample') from tarantool.lua

@_silgen_name("luaopen_ModuleExample")
public func open(L: OpaquePointer!) -> Int32 {
    return 0
}
