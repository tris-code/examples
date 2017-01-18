import MessagePack
import TarantoolModule
import CTarantool

struct ModuleError: Error, CustomStringConvertible {
    let message: String

    var description: String {
        return message
    }
}

@_silgen_name("helloSwift")
func helloSwift(context: BoxContext) -> BoxResult {
    return context.returnTuple(.string("hello from swift"))
}

@_silgen_name("getFoo")
func getFoo(context: BoxContext) -> BoxResult {
    do {
        let schema = try Schema(BoxDataSource())

        guard let space = schema.spaces["data"] else {
            return BoxError.returnError(code: .noSuchSpace, message: "space 'data' not found")
        }

        try space.replace(["foo", "bar"])

        guard let result = try space.get(["foo"]) else {
            return BoxError.returnError(code: .tupleNotFound, message: "foo not found")
        }

        return context.returnTuple(.array(result))
    } catch {
        return BoxError.returnError(code: .procC, message: String(describing: error))
    }
}

@_silgen_name("getCount")
func getCount(context: BoxContext, argsStart: UnsafePointer<UInt8>, argsEnd: UnsafePointer<UInt8>) -> BoxResult {
    do {
        let schema = try Schema(BoxDataSource())

        let args = try MessagePack.deserialize(bytes: argsStart, count: argsEnd - argsStart)
        guard let name = Tuple(args)?.first, let spaceName = String(name) else {
            throw ModuleError(message: "incorrect space name argument")
        }

        guard let space = schema.spaces[spaceName] else {
            return BoxError.returnError(code: .noSuchSpace, message: "space '\(spaceName)' not found")
        }

        let count = try space.count()

        return context.returnTuple(.int(count))
    } catch {
        return BoxError.returnError(code: .procC, message: String(describing: error))
    }
}
