import AsyncFiber
import TarantoolConnector

AsyncFiber().registerGlobal()

async.task {
    do {
        let iproto = try IProto(host: "127.0.0.1")

        print(try iproto.call("hello_swift_native"))
        print(try iproto.call("get_foo_native"))
        print(try iproto.call("get_count_native", arguments: ["test"]))
        print(try iproto.call("eval_lua_native"))
        print()
        print(try iproto.call("hello_swift"))
        print(try iproto.call("get_foo"))
        print(try iproto.call("get_count", arguments: ["test"]))
        print(try iproto.call("eval_lua"))
        print()
        print(try iproto.call("test_lua"))

    } catch {
        print(error)
    }
}

async.loop.run()
