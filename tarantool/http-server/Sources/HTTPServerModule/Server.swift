import Log
import HTTP
import MessagePack
import TarantoolModule

struct SomeError: Swift.Error {}

func registerRoutes(in server: Server) throws {
    let schema = try Schema(Box())

    guard let space = schema.spaces["data"] else {
        Log.error("space 'data' not found")
        return
    }

    var counter = 0

    server.route(get: "/json") {
        let rows = try space.select(iterator: .all).map { $0.unpack() }
        let strings = rows.map { $0.compactMap{ $0.stringValue } }
        return try Response(body: strings)
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
}

@_silgen_name("entry_point")
public func main() -> Int {
    async.use(Tarantool.self)

    async.task {
        do {
            let server = try Server(host: "0.0.0.0", port: 8080)
            try registerRoutes(in: server)
            try server.start()
        } catch {
            Log.error(String(describing: error))
        }
    }

    return 0
}
