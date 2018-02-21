import TarantoolModule
import MessagePack
import HTTP
import Log

struct SomeError: Swift.Error {}

func runServer() throws {
    let server = try Server(host: "0.0.0.0", port: 8080)

    let schema = try Schema(Box())

    guard let space = schema.spaces["data"] else {
        Log.error("space 'data' not found")
        return
    }

    var counter = 0

    struct Model {
        let fields: [String]

        init<T: Tarantool.Tuple>(_ tuple: T) {
            self.fields = tuple.map { String($0 as! MessagePack)! }
        }
    }

    server.route(get: "/json") {
        let tuples = try space.select(iterator: .all)
        return try Response(body: tuples.map { Model($0).fields })
    }

    server.route(get: "/*") {
        counter += 1
        try transaction {
            try space.replace(["foo", .string("bar \(counter)")])
        }

        try? transaction {
            try space.replace(["foo", "rollback"])
            throw SomeError()
        }

        guard let result = try space.get(keys: ["foo"]) else {
            Log.error("foo not found")
            return Response(status: .notFound)
        }

        return try Response(body: result[1, as: String.self] ?? "not a string")
    }

    try server.start()
}

@_silgen_name("entry_point")
public func main() -> Int {
    async.use(Tarantool.self)
    async.task {
        do {
            try runServer()
        } catch {
            Log.error(String(describing: error))
        }
    }
    return 0
}
