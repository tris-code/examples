import HTTP
import Async

func registerRoutes(in server: Server) throws {

    // MARK: Simple

    server.route(get: "/ascii") {
        return "hey there!"
    }

    server.route(get: "/юникод") {
        return "привет!"
    }

    // MARK: URL Match

    server.route(get: "/swift/string/:string") { (name: String) in
        return "name: \(name)"
    }

    server.route(get: "/swift/int/:integer") { (id: Int) in
        return "id: \(id)"
    }

    struct Date: Decodable {
        let day: Int
        let month: String
    }

    server.route(get: "/decode-from-url/:month/:day") { (date: Date) in
        return "date: \(date)"
    }

    // MARK: Body

    struct Event: Decodable {
        let name: String
    }

    server.route(post: "/decode-json-or-form-urlencoded") { (event: Event) in
        return "event: \(event)"
    }

    // MARK: URL match + Body

    server.route(post: "/date/:month/:day") { (date: Date, event: Event) in
        return """
            date from url: \(date)
            model from body: \(event)
            """
    }

    // MARK: Wildcard

    server.route(get: "/*") { (request: Request) in
        return "wildcard: \(request.url.path)"
    }

    // MARK: Application

    let api = Application(basePath: "/api" /* middleware: [] */)
    api.route(get: "/versions") { return ["v1"] }

    let v1 = Application(basePath: "/v1" /* middleware: [] */)
    v1.route(get: "/test") { return "/api/v1/test" }

    api.addApplication(v1)
    server.addApplication(api)
}
