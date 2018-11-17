import HTTP
import Async

func registerRoutes(in server: Server) throws {
    registerVariousRoutes(in: server)
    registerQuickStartRoutes(in: server)
}
