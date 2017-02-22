import MessagePack
import TarantoolModule

struct ModuleError: Error, CustomStringConvertible {
    let description: String
}

func helloSwift() -> MessagePack {
    return "hello from swift"
}

func getFoo() throws -> MessagePack {
    let schema = try Schema(BoxDataSource())

    guard let space = schema.spaces["data"] else {
        throw BoxError(code: .noSuchSpace, message: "space 'data' not found")
    }

    try space.replace(["foo", "bar"])

    guard let result = try space.get(["foo"]) else {
        throw BoxError(code: .tupleNotFound, message: "foo not found")
    }
    return .array(result)
}

func getCount(args: [MessagePack]) throws -> MessagePack {
    let schema = try Schema(BoxDataSource())

    guard let first = args.first, let spaceName = String(first) else {
        throw ModuleError(description: "incorrect space name argument")
    }

    guard let space = schema.spaces[spaceName] else {
        throw BoxError(code: .noSuchSpace, message: "space '\(spaceName)' not found")
    }

    let count = try space.count()
    return .int(count)
}
