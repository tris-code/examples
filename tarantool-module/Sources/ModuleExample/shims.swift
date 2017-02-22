import MessagePack
import TarantoolModule
import CTarantool

// it just looks much cleaner until we find a better solution

@_silgen_name("helloSwift")
func helloSwiftShim(context: BoxContext) -> BoxResult {
    return Box.returnTuple(helloSwift(), to: context)
}

@_silgen_name("getFoo")
func getFooShim(context: BoxContext) -> BoxResult {
    do {
        let result = try getFoo()
        return Box.returnTuple(result, to: context)
    } catch let error as BoxError {
        return Box.returnError(code: error.code, message: error.message)
    } catch {
        return Box.returnError(code: .procC, message: String(describing: error))
    }
}

@_silgen_name("getCount")
func getCountShim(context: BoxContext, argsStart: UnsafePointer<UInt8>, argsEnd: UnsafePointer<UInt8>) -> BoxResult {
    do {
        let object = try MessagePack.decode(bytes: argsStart, count: argsEnd - argsStart)
        guard let args = Tuple(object) else {
            throw ModuleError(description: "expected msgpack array")
        }
        let result = try getCount(args: args)
        return Box.returnTuple(result, to: context)
    } catch let error as BoxError {
        return Box.returnError(code: error.code, message: error.message)
    } catch {
        return Box.returnError(code: .procC, message: String(describing: error))
    }
}
