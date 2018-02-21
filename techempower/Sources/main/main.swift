import Log
import HTTP
import Fiber
import Foundation

Log.enabled = false

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

        try server.start()
    } catch {
        print(String(describing: error))
    }
}

#if os(Linux)
let threadsCount: Int
if ProcessInfo.processInfo.arguments.count == 2,
    let count = Int(ProcessInfo.processInfo.arguments[1]) {
    guard count >= 1 else {
        print("thread count should be >= 1")
        exit(1)
    }
    threadsCount = count - 1
} else {
    threadsCount = ProcessInfo.processInfo.activeProcessorCount - 1
}

print("running \(threadsCount + 1) thread\(threadsCount != 0 ? "s" : "")")

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
