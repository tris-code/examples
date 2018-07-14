import HTTP
import Fiber

async.use(Fiber.self)

async.task {
    do {
        let server = try Server(host: "localhost", port: 8181)
        configureServer(server)
        try server.start()
    } catch {
        print(error)
    }
}

async.loop.run()
