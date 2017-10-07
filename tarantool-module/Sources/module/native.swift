import MessagePack
import TarantoolModule

// Pros: Performance, module reload
// Cons: Addition of a new function is annoying, harder to read: a lot of noise

// To add a new funcion you have to:
//   1. copy/paste this signature (or remember)
//   3. add of fix @_silgen_name("")
//   2. modify lua bootstrap script

@_silgen_name("helloSwiftNative")
public func helloSwift(context: BoxContext) -> BoxResult {
    return Box.convertCall(context) {
        return [.string("hello from swift")]
    }
}

@_silgen_name("getFooNative")
public func getFoo(context: BoxContext) -> BoxResult {
    return Box.convertCall(context) {
        guard let space = schema.spaces["data"] else {
            throw BoxError(code: .noSuchSpace, message: "space: 'data'")
        }

        try space.replace(["foo", "bar"])

        guard let result = try space.get(keys: ["foo"]) else {
            throw BoxError(code: .tupleNotFound, message: "keys: foo")
        }
        return result.rawValue
    }
}

@_silgen_name("getCountNative")
public func getCount(
    context: BoxContext,
    start: UnsafePointer<UInt8>,
    end: UnsafePointer<UInt8>
) -> BoxResult {
    return Box.convertCall(context, start, end) { arguments in
        guard let name = String(arguments.first) else {
            throw ModuleError(description: "incorrect space name argument")
        }

        guard let space = schema.spaces[name] else {
            throw BoxError(code: .noSuchSpace, message: "space: '\(name)'")
        }

        let count = try space.count()
        return [.int(count)]
    }
}

@_silgen_name("evalLuaScriptNative")
public func evalLuaScript(context: BoxContext) -> BoxResult {
    return Box.convertCall(context) {
        return try Lua.eval("return 40 + 2")
    }
}
