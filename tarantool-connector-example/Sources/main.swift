import Foundation
import TarantoolConnector

do {

    let connection = try IProtoConnection(host: "127.0.0.1")
    try connection.auth(username: "tester", password: "tester")

    let source = IProtoDataSource(connection: connection)
    let schema = try Schema(source)

    guard let test = schema.spaces["test"] else {
        print("space test not found")
        exit(0)
    }

    var result = try test.select(.eq, keys: [3])
    print(result) // prints [[3, "baz"]]

    try test.replace([42, "Answer to the Ultimate Question of Life, The Universe, and Everything"])
    result = try test.select(.eq, keys: [42])
    print(result) // prints [42, "Answer to the Ultimate Question of Life, The Universe, and Everything"]

} catch {
    print(error)
}
