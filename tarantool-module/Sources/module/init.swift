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

    let lua = Lua(stack: L)

    for (name, _) in tasks {
        lua.push(name)
        lua.push(closure, upValuesCount: 1)
        lua.setGlobal(name: name)
    }

    // usual module exports example

    func register(_ regs: [Reg]) {
        // we need to keep string pointers alive
        withUnsafeRegs(regs) { luaRegs in
            lua.setFuncs(luaRegs)
        }
    }

    register([
        Reg(name: "exported1", function: exported1),
        Reg(name: "exported2", function: exported2)
    ])

    // we can also export the to the global scope
    lua.pushValue(at: -1) // copy the table
    lua.setGlobal(name: "swift_tarantool_module")

    return 1
}

struct Reg {
    let name: String
    let function: lua_CFunction
}

func withUnsafeRegs(_ regs: [Reg], _ task: ([luaL_Reg]) -> Void) {
    var luaRegs = regs.map { reg in
        luaL_Reg(name: strdup(reg.name), func: reg.function)
    }
    luaRegs.append(luaL_Reg(name: nil, func: nil))
    task(luaRegs)
    luaRegs.forEach { free(UnsafeMutableRawPointer(mutating: $0.name)) }
}

public func exported1(L: OpaquePointer!) -> Int32 {
    print("exported 1")
    return 0
}

public func exported2(L: OpaquePointer!) -> Int32 {
    print("exported 2")
    return 0
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

public func closure(L: OpaquePointer!) -> Int32 {
    let lua = Lua(stack: L)
    do {
        guard let name = lua.get(String.self, at: lua.upValueIndex(1)),
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
        lua.push("\(error)")
        return -1
    }
}
