import MessagePack
import TarantoolModule
import CTarantool

typealias BoxResult = Int32

struct ModuleError: Error {
    let message: String
}

@_silgen_name("helloSwift")
func helloSwift(context: OpaquePointer) -> BoxResult {
    return Box.returnTuple(["hello from swift"], to: context)
}


@_silgen_name("getFoo")
func getFoo(context: OpaquePointer, argsStart: UnsafePointer<UInt8>, argsEnd: UnsafePointer<UInt8>) -> BoxResult {
    do {
        let source = BoxDataSource()
        let schema = try Schema(source)

        guard let space = schema.spaces["data"] else {
            throw ModuleError(message: "space 'data' not found")
        }

        guard let result = try space.get(["foo"]) else {
            throw ModuleError(message: "foo not found")
        }

        return Box.returnTuple(result, to: context)
    } catch {
        Say.error(message: String(describing: error))
        return -1
    }
}
