import MessagePack
import TarantoolModule

// Pros: Clean functions, no visible wrappers and other noise
// Cons: Relatively slower, complex bootstrap (init.swift, tarntool.lua)

// To add a new function you have to:
//   1. call RegisterProcedure function

func registerProcedures(procedure: RegisterProcedure) {
    procedure("hello_swift") { _, output in
        try output.append(["hewllo"])
        try output.append(["from"])
        try output.append(["swift"])
    }

    procedure("get_foo") { _, output in
        guard let space = schema.spaces["data"] else {
            throw Box.Error(code: .noSuchSpace, message: "space: 'data'")
        }

        try space.replace(["foo", "bar"])

        guard let result = try space.get(keys: ["foo"]) else {
            throw Box.Error(code: .tupleNotFound, message: "keys: foo")
        }
        try output.append(result)
        try output.append(result)
    }

    procedure("get_count") { arguments, output in
        guard let name = String(arguments.first) else {
            throw ModuleError(description: "incorrect space name argument")
        }

        guard let space = schema.spaces[name] else {
            throw Box.Error(code: .noSuchSpace, message: "space: '\(name)'")
        }

        let count = try space.count()
        try output.append([.int(count)])
    }

    procedure("eval_lua") { arguments, output in
        var result = try Lua.eval("return 40 + 2")
        result.insert("eval result", at: 0)
        try output.append(result)
    }
}
