import MessagePack
import TarantoolModule

struct ModuleError: Error, CustomStringConvertible {
    let description: String
}

func helloSwift() -> MessagePack {
    return "hello from swift"
}

func getFoo() throws -> MessagePack {
    let schema = try Schema(Box())

    guard let space = schema.spaces["data"] else {
        throw BoxError(code: .noSuchSpace, message: "space 'data' not found")
    }

    try space.replace(["foo", "bar"])

    guard let result = try space.get(keys: ["foo"]) else {
        throw BoxError(code: .tupleNotFound, message: "foo not found")
    }
    return .array(result.rawValue)
}

func getCount(args: [MessagePack]) throws -> MessagePack {
    let schema = try Schema(Box())

    guard let name = String(args.first) else {
        throw ModuleError(description: "incorrect space name argument")
    }

    guard let space = schema.spaces[name] else {
        throw BoxError(code: .noSuchSpace, message: "space '\(name)' not found")
    }

    let count = try space.count()
    return .int(count)
}

func evalLuaScript() throws -> MessagePack {
    return .array(try Lua.eval("return 40 + 2"))
}
