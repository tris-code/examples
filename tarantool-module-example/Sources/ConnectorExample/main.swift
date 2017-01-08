import Foundation
import TarantoolConnector

do {
    let iproto = try IProtoConnection(host: "127.0.0.1")

    print(try iproto.call("helloLua"))
    print(try iproto.call("helloSwift"))
    print(try iproto.call("getFoo"))

} catch {
    print(error)
}
