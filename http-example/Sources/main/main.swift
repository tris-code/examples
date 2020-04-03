import HTTP
import Fiber

async.use(Fiber.self)

async.main {
    let server = try Server(host: "localhost", port: 8080)
    try registerRoutes(in: server)
    try server.start()
}

async.main {
    let client = Client(host: "localhost", port: 8080)
    try makeRequests(using: client)
}

async.loop.run()
