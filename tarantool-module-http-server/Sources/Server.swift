import AsyncTarantool
import TarantoolModule
import HTTPServer
import Log

struct SomeError: Error {}

func runServer() throws {
    let server = try Server(host: "0.0.0.0", port: 8080, async: AsyncTarantool())

    let source = BoxDataSource()
    let schema = try Schema(source)

    guard let space = schema.spaces["data"] else {
        Log.error("space 'data' not found")
        return
    }

    var counter = 0

    server.route(get: "/*") { (request: HTTPRequest) in
        do {
            counter += 1
            try transaction {
                try space.replace(["foo", .string("bar \(counter)")])
                return .commit
            }

            try transaction {
                try space.replace(["foo", "rollback"])
                return .rollback
            }

            try transaction {
                try space.replace(["foo", "also rollback"])
                throw SomeError()
            }

            guard let result = try space.get(["foo"]) else {
                Log.error("foo not found")
                return HTTPResponse(status: .notFound)
            }

            return String(result[1]) ?? "error"
        } catch {
            return HTTPResponse(status: .internalServerError)
        }
    }

    try server.start()
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
