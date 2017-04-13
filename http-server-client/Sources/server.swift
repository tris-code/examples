import Async
import Server

func runServer(async: Async) throws {
    // 0. Create server
    let server = try Server(host: "0.0.0.0", port: 8080, async: async)

    // 1. Simple route
    server.route(get: "/hello") {
        return "hey there!"
    }

    // 2. Map url param to primitive types
    server.route(get: "/hello/:name") { (name: String) in
        return "hey \(name)!"
    }

    server.route(get: "/robot/:id") { (id: Int) in
        return "Hello. My name is Robo\(id). I'm here to.. BSOD"
    }

    // Reflection

    // 3.1. get method
    struct Page {
        let name: String
        let skip: Int
    }
    // you can mix values from url and query:
    // example: /page/news?skip=2
    server.route(get: "/page/:name") { (page: Page) in
        return page
    }

    // 3.2. post data
    struct TodoUpdate {
        let name: String
        let done: Bool
    }
    // urlencoded example: name=sleep+sometimes&done=false
    // json example: {"name": "sleep sometimes", "done": false}
    server.route(post: "/todo") { (todo: TodoUpdate) in
        return todo
    }
    // you can also mix values from url and post body:
    // example: /todo/commitChanges
    // post query: done=true
    server.route(post: "/todo/:name") { (todo: TodoUpdate) in
        return todo
    }
    // 3.3. serialize model into json
    server.route(get: "/todo/as/json") {
        return TodoUpdate(name: "serialized", done: true)
    }

    // 4. Use request & return handcoded json
    server.route(get: "/request") { request in
        return [
            "method": String(describing: request.method),
            "url": request.url.path,
        ]
    }

    // 5. Wildcard
    server.route(get: "/*") { (request: Request) in
        return "wildcard: \(request.url.path)"
    }

    try server.start()
}
