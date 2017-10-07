import CTarantool
import AsyncTarantool
import TarantoolModule
import MessagePack

// called by require('SwiftTarantoolModule') from tarantool.lua

@_silgen_name("luaopen_SwiftTarantoolModule")
public func open(L: OpaquePointer!) -> Int32 {
    // use tarantool fibers in async
    AsyncTarantool().registerGlobal()

    // 1. you don't need the rest if you only use native way:
    // return 0

    // 2. register stored procedures
    registerProcedures(procedure: registerFunction)

    for (name, _) in tasks {
        export(L, name, call)
    }
    return Int32(tasks.count)
}

typealias SwiftProcedure = ([MessagePack]) throws -> [MessagePack]
typealias RegisterProcedure = (_ name: String, @escaping SwiftProcedure) -> Void

var tasks: [String : SwiftProcedure] = [:]
func registerFunction(name: String, task: @escaping SwiftProcedure) {
    tasks[name] = task
}

private func export(
    _ L: OpaquePointer!,
    _ name: String,
    _ function: @escaping lua_CFunction
) {
    name.withCString { ptr in
        let regs = [
            luaL_Reg(name: ptr, func: function),
            luaL_Reg(name: nil, func: nil)
        ]
        _luaL_register(L, "SwiftTarantoolModule", regs)
    }
}

public func call(L: OpaquePointer!) -> Int32 {
    do {
        guard let name = String(try Lua.popFirst(from: L)),
            let task = tasks[name] else {
                return -1
        }
        let arguments = try Lua.popValues(from: L!)
        let result = try task(arguments)
        try Lua.push(values: result, to: L!)
        return Int32(result.count)
    } catch {
        try! Lua.push(values: [.string("\(error)")], to: L!)
        return -1
    }
}
