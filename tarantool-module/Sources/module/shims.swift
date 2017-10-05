import MessagePack
import TarantoolModule

// it just looks much cleaner until we find a better solution

@_silgen_name("helloSwift")
public func helloSwiftShim(context: BoxContext) -> BoxResult {
    return Box.returnTuple(helloSwift(), to: context)
}

@_silgen_name("getFoo")
public func getFooShim(context: BoxContext) -> BoxResult {
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
public func getCountShim(
    context: BoxContext,
    argsStart: UnsafePointer<UInt8>,
    argsEnd: UnsafePointer<UInt8>
) -> BoxResult {
    do {
        let object = try MessagePack.decode(from: InputRawStream(
            pointer: argsStart, count: argsEnd - argsStart))
        guard let args = [MessagePack](object) else {
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

@_silgen_name("evalLuaScript")
public func evalLuaScriptShim(context: BoxContext) -> BoxResult {
    do {
        return Box.returnTuple(try evalLuaScript(), to: context)
    } catch let error as BoxError {
        return Box.returnError(code: error.code, message: error.message)
    } catch {
        return Box.returnError(code: .procC, message: String(describing: error))
    }
}
