import Foundation
import TarantoolConnector

do {
    let iproto = try IProtoConnection(host: "127.0.0.1")

    print(try iproto.call("helloLua"))
    print(try iproto.call("helloSwift"))
    print(try iproto.call("getFoo"))
    print(try iproto.call("getCount", arguments: ["test"]))
    print(try iproto.call("evalLuaScript"))

} catch {
    print(error)
}
