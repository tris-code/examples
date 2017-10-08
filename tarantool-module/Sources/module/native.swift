import MessagePack
import TarantoolModule

// Pros: Performance, module reload
// Cons: Addition of a new function is annoying, harder to read: a lot of noise

// To add a new funcion you have to:
//   1. copy/paste this signature (or remember)
//   3. add of fix @_silgen_name("")
//   2. modify lua bootstrap script

@_silgen_name("hello_swift_native")
public func helloSwift(context: Box.Context) -> Box.Result {
    return Box.convertCall(context) { output in
        try output.append(["hello"])
        try output.append(["from"])
        try output.append(["swift"])
    }
}

@_silgen_name("get_foo_native")
public func getFoo(context: Box.Context) -> Box.Result {
    return Box.convertCall(context) { output in
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
}

@_silgen_name("get_count_native")
public func getCount(
    context: Box.Context,
    start: UnsafePointer<UInt8>,
    end: UnsafePointer<UInt8>
) -> Box.Result {
    return Box.convertCall(context, start, end) { arguments, output in
        guard let name = String(arguments.first) else {
            throw ModuleError(description: "incorrect space name argument")
        }

        guard let space = schema.spaces[name] else {
            throw Box.Error(code: .noSuchSpace, message: "space: '\(name)'")
        }

        let count = try space.count()
        try output.append([.int(count)])
    }
}

@_silgen_name("eval_lua_native")
public func evalLuaScript(context: Box.Context) -> Box.Result {
    return Box.convertCall(context) { output in
        var result = try Lua.eval("return 40 + 2")
        result.insert("eval result", at: 0)
        try output.append(result)
    }
}
