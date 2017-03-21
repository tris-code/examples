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

    let equal = try test.select(.eq, keys: [3])
    equal.forEach { print($0) }
    // [[3, "baz"]]

    let all = try test.select(.all)
    all.forEach { print($0) }
    // first run: [[1, "foo"], [2, "bar"], [3, "baz"]]
    // second run: [[42, "Answer to the Ultimate Question of Life, The Universe, and Everything"], [1, "foo"], ...]

    try test.replace([42, "Answer to the Ultimate Question of Life, The Universe, and Everything"])
    if let answer = try test.get([42]) {
        print(answer)
    }
    // [42, "Answer to the Ultimate Question of Life, The Universe, and Everything"]

} catch {
    print(error)
}
