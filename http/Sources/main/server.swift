import HTTP
import Async

func runServer() throws {
    // 0. Create server
    let server = try Server(host: "0.0.0.0", port: 8080)

    // 1. Simple routes
    // supported methods: get, head, post, put, delete, options, all

    // ascii
    server.route(get: "/hello") {
        return "Hello, World!"
    }

    // unicode
    server.route(get: "/привет") {
        return "привет!"
    }

    // 2. Use Request data
    server.route(get: "/request") { (request: Request) in
        return request.url.path
    }

    // 3. Match url params
    server.route(get: "/page/:string") { (name: String) in
        return "page name: \(name)"
    }

    server.route(get: "/user/:integer") { (id: Int) in
        return "user id: \(id)"
    }

    // 4. Custom model
    struct Todo: Codable {
        let name: String
        let done: Bool
    }

    // Encode response to json
    server.route(get: "/todos") {
        return [
            Todo(name: "One", done: true),
            Todo(name: "Two", done: false)
        ]
    }

    // Decode request from json or form-urlencoded
    server.route(post: "/todo") { (todo: Todo) in
        return todo
    }

    // 5. Use all together
    struct Date: Decodable {
        let day: Int
        let month: String
    }

    struct Event: Decodable {
        let name: String
    }

    // Pass request, match url, decode post data
    server.route(post: "/date/:month/:day")
    { (request: Request, date: Date, event: Event) in
        return """
            request url: \(request.url)
            date from url: \(date)
            model from body: \(event)
            """
    }

    // 6. Wildcard
    server.route(get: "/*") { (request: Request) in
        return "wildcard: \(request.url.path)"
    }

    try server.start()
}
