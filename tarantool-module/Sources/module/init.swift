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
    let lua = Lua(stack: L)
    do {
        guard let name = String(try lua.popFirst()),
            let task = tasks[name] else {
                return -1
        }
        let arguments = try lua.popValues()
        let result = try task(arguments)
        try lua.push(.array([.array(result)]))
        return 1
    } catch {
        try! lua.push(values: [.string("\(error)")])
        return -1
    }
}
