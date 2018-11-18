import Log
import HTTP
import Fiber

Log.isEnabled = false

async.use(Fiber.self)

func startServer() {
    do {
        let server = try Server(host: "0.0.0.0", reusePort: 8080)

        server.route(get: "/plaintext") {
            return "Hello, World!"
        }

        struct JSON: Encodable {
            let message: String
        }

        server.route(get: "/json") {
            return JSON(message: "Hello, World!")
        }

        print("starting server at \(server.address)")
        try server.start()
    } catch {
        print(String(describing: error))
    }
}

#if os(Linux)
for _ in 0..<threadsCount {
    Thread {
        async.task {
            startServer()
        }
        async.loop.run()
    }.start()
}
#endif

async.task {
    startServer()
}

async.loop.run()
