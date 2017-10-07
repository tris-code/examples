import MessagePack
import TarantoolModule

// Pros: Clean functions, no visible wrappers and other noise
// Cons: Relatively slower, complex bootstrap (init.swift, tarntool.lua)

// To add a new function you have to:
//   1. call RegisterProcedure function

func registerProcedures(procedure: RegisterProcedure) {
    procedure("helloSwift") { arguments in
        return [.string("hello from swift")]
    }

    procedure("getFoo") { _ in
        guard let space = schema.spaces["data"] else {
            throw BoxError(code: .noSuchSpace, message: "space: 'data'")
        }

        try space.replace(["foo", "bar"])

        guard let result = try space.get(keys: ["foo"]) else {
            throw BoxError(code: .tupleNotFound, message: "keys: foo")
        }
        return result.rawValue
    }

    procedure("getCount") { arguments in
        guard let name = String(arguments.first) else {
            throw ModuleError(description: "incorrect space name argument")
        }

        guard let space = schema.spaces[name] else {
            throw BoxError(code: .noSuchSpace, message: "space: '\(name)'")
        }

        let count = try space.count()
        return [.int(count)]
    }

    procedure("evalLuaScript") { arguments in
        return try Lua.eval("return 40 + 2")
    }
}
