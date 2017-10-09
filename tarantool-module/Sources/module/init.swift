import CTarantool
import AsyncTarantool
import TarantoolModule
import MessagePack

// called by require('swift_tarantool_module') from tarantool.lua

@_silgen_name("luaopen_swift_tarantool_module")
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

//******************************************************************************
//* WARING: THIS IS A COMPLETE HACK, JUST A TRY TO FIND A BETTER WAY           *
//******************************************************************************

public struct Output {
    let lua: Lua
    var count: Int

    init(lua: Lua) {
        self.lua = lua
        self.count = 0
    }

    public mutating func append(_ tuple: Box.Tuple) throws {
        try lua.push(.array(tuple.unpack()))
        lua.rawSet(toTableAt: -2, at: count + 1)
        count += 1
    }

    public mutating func append(_ tuple: [MessagePack]) throws {
        try lua.push(.array(tuple))
        lua.rawSet(toTableAt: -2, at: count + 1)
        count += 1
    }
}

typealias SwiftProcedure = ([MessagePack], inout Output) throws -> Void
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
        lua.createTable()
        var output = Output(lua: lua)
        try task(arguments, &output)
        lua.setTypeHint(forTableAt: -1, type: .array)
        return 1
    } catch {
        try! lua.push(values: [.string("\(error)")])
        return -1
    }
}
