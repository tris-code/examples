import AsyncTarantool
import TarantoolModule
import Server
import Log

struct SomeError: Error {}

func runServer() throws {
    let server = try Server(host: "0.0.0.0", port: 8080, async: AsyncTarantool())

    let schema = try Schema(Box())

    guard let space = schema.spaces["data"] else {
        Log.error("space 'data' not found")
        return
    }

    var counter = 0

    server.route(get: "/json") {
        let tuples = try space.select(.all)
        return try Response(serializing: tuples)
    }

    server.route(get: "/*") { (request: Request) in
        counter += 1
        try transaction {
            try space.replace(["foo", .string("bar \(counter)")])
            return .commit
        }

        try transaction {
            try space.replace(["foo", "rollback"])
            return .rollback
        }

        try? transaction {
            try space.replace(["foo", "also rollback"])
            throw SomeError()
        }

        guard let result = try space.get(["foo"]) else {
            Log.error("foo not found")
            return Response(status: .notFound)
        }

        return result[1, as: String.self] ?? "not a string"
    }

    try server.start()
}

extension Response {
    init<T: Tuple>(serializing tuples: AnySequence<T>) throws {
        var strings = [String]()
        for tuple in tuples {
            strings.append(String(describing: tuple.rawValue))
        }
        let result = "[\(strings.joined(separator: ", "))]"
        var response = Response()
        response.contentType = .json
        response.rawBody = [UInt8](result)
        self = response
    }
}

@_silgen_name("entry_point")
public func main() -> Int {
    do {
        try runServer()
    } catch {
        Log.error(String(describing: error))
    }
    return 0
}
