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

    print(try test.select(.eq, keys: [3]))
    // [[3, "baz"]]

    print(try test.select(.all))
    // first run: [[1, "foo"], [2, "bar"], [3, "baz"]]
    // second run: [[42, "Answer to the Ultimate Question of Life, The Universe, and Everything"], [1, "foo"], ...]

    try test.replace([42, "Answer to the Ultimate Question of Life, The Universe, and Everything"])
    print(try test.select(.eq, keys: [42]))
    // [42, "Answer to the Ultimate Question of Life, The Universe, and Everything"]

} catch {
    print(error)
}
