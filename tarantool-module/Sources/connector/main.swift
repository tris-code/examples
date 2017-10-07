import AsyncFiber
import TarantoolConnector

AsyncFiber().registerGlobal()

async.task {
    do {
        let iproto = try IProtoConnection(host: "127.0.0.1")

        print(try iproto.call("helloLua"))
        print()
        print(try iproto.call("helloSwiftNative"))
        print(try iproto.call("getFooNative"))
        print(try iproto.call("getCountNative", arguments: ["test"]))
        print(try iproto.call("evalLuaScriptNative"))
        print()
        print(try iproto.call("helloSwift"))
        print(try iproto.call("getFoo"))
        print(try iproto.call("getCount", arguments: ["test"]))
        print(try iproto.call("evalLuaScript"))
    } catch {
        print(error)
    }
}

async.loop.run()
