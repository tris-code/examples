import CTarantool
import AsyncTarantool

// called by require('SwiftTarantoolModule') from tarantool.lua

@_silgen_name("luaopen_SwiftTarantoolModule")
public func open(L: OpaquePointer!) -> Int32 {
    // use tarantool fibers in async
    AsyncTarantool().registerGlobal()
    // you can also export your functions to Lua
    // without registering it as box stored procedures
    let exports: [(name: String, pointer: lua_CFunction)] = [
        ("func1", func1),
        ("func2", func2),
    ]
    for function in exports {
        export(L, function.name, function.pointer);
    }
    return Int32(exports.count)
}

private func export(
    _ L: OpaquePointer!,
    _ name: String,
    _ function: @escaping CTarantool.lua_CFunction
) {
    name.withCString { ptr in
        let regs = [
            luaL_Reg(name: ptr, func: function),
            luaL_Reg(name: nil, func: nil)
        ]
        _luaL_register(L, "SwiftTarantoolModule", regs);
    }
}

public func func1(L: OpaquePointer?) -> Int32 {
    print("swift func1")
    return 0
}

public func func2(L: OpaquePointer?) -> Int32 {
    print("swift func2")
    return 0
}
