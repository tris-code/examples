import Async
import Server

func runServer() throws {
    // 0. Create server
    let server = try Server(host: "0.0.0.0", port: 8080)

    // 1. Simple route
    server.route(get: "/hello") {
        return "hey there!"
    }

    // Decodable

    // 2. Decode url
    server.route(get: "/hello/:string") { (name: String) in
        return "hey \(name)!"
    }

    server.route(get: "/user/:integer") { (id: Int) in
        return "get user where id=\(id)"
    }

    // 3. Custom model
    struct Todo: Codable {
        let name: String
        let done: Bool
    }

    // 3.1. Encode response to json
    server.route(get: "/todos") {
        return [
            Todo(name: "One", done: true),
            Todo(name: "Two", done: false)
        ]
    }

    // 3.2. Decode request from json | form-urlencoded
    server.route(post: "/todo") { (todo: Todo) in
        return todo
    }

    // 4. Custom url & request model
    struct Date: Decodable {
        let day: Int
        let month: String
    }
    struct Event: Decodable {
        let name: String
    }

    // 4.1. Pass request & decode url + body
    server.route(post: "/date/:month/:day")
    { (request: Request, date: Date, event: Event) in
        return "\(request.url) \(date) \(event)"
    }

    // 5. Wildcard
    server.route(get: "/*") { (request: Request) in
        return "wildcard: \(request.url.path)"
    }

    try server.start()
}
