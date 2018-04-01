import Log
import HTTP
import Fiber
import Platform

async.use(Fiber.self)

async.task {
    trycatch {
        let server = try Server(host: "0.0.0.0", port: 8080)
        try registerRoutes(in: server)
        try server.start()
    }
}

async.task {
    trycatch {
        let client = Client(host: "0.0.0.0", port: 8080)
        try makeRequests(using: client)
    }
}

async.loop.run()
