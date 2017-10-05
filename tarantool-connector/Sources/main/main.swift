import Foundation
import AsyncFiber
import TarantoolConnector

AsyncFiber().registerGlobal()

async.task {
    do {
        let connection = try IProtoConnection(host: "127.0.0.1")
        try connection.auth(username: "tester", password: "tester")

        let iproto = IProto(connection: connection)
        var schema = try Schema(iproto)

        guard let test = schema.spaces["test"] else {
            print("space test not found")
            exit(1)
        }

        // select by key
        let equal = try test.select(.eq, keys: [3])
        equal.forEach { print($0) }

        // select all
        let all = try test.select(.all)
        all.forEach { print($0) }

        // replace
        try test.replace([42, "Answer to the Ultimate Question of Life, The Universe, and Everything"])
        if let answer = try test.get([42]) {
            print(answer)
        }

        // eval example
        let result = try iproto.eval("return 40 + 2")
        print(result)

        // create space & index
        if schema.spaces["new_space"] == nil {
            try connection.auth(username: "admin", password: "admin")
            var space = try schema.createSpace(name: "new_space")
            try space.createIndex(name: "new_index", sequence: true)
        }
        guard let newSpace = schema.spaces["new_space"] else {
            print("new_space doesn't exist")
            exit(1)
        }
        // autoincrementing index
        try newSpace.insert([nil, "test1"])
        try newSpace.insert([nil, "test2"])
        let newResult = try newSpace.select(.all)
        newResult.forEach { print($0) }
    } catch {
        print(error)
    }
}

async.loop.run()
