import Log
import AsyncFiber
import AsyncDispatch
import HTTPServer
import Foundation

// disable debug output
Log.delegate = { level, message in
    if level != .debug {
        print("[\(level)] \(message)")
    }
}

// you can also completely disable the Log system
//Log.disabled = true


// 0. Create server

// AsyncDispatch - preemptive multitasking, spawns Dispatch task for each connection
// AsyncFiber - cooperative multitasking, runs new fiber for each connection

let server = try Server(host: "0.0.0.0", port: 8080, async: AsyncFiber())

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

// 3. Reflection

// 3.1. map url params to custom model

struct Page {
    let name: String
    let skip: Int
}

// you can also mix url and query params:
// example: /page/news?skip=2
server.route(get: "/page/:name") { (page: Page) in
    return "page \(page.name), skip \(page.skip)"
}

// 3.2. post data

struct TodoUpdate {
    let name: String
    let done: Bool
}

// post query example: name=commitChanges&done=true
server.route(post: "/todo") { (todo: TodoUpdate) in
    return "todo \(todo.name) state \(todo.done)"
}

// example: /todo/commitChanges
// post query: done=true
server.route(post: "/todo/:name") { (todo: TodoUpdate) in
    return "todo mix \(todo.name) state \(todo.done)"
}

// 3.3. serialize model into json

server.route(get: "/todo/as/json") {
    return TodoUpdate(name: "serialized", done: true)
}

// 4. Use request data & return json dictionary

server.route(get: "/request") { request in
    return [
        "url": request.url,
        "host": request.host,
        "user-agent": request.userAgent
    ]
}

// 5. Wildcard

server.route(get: "/*") { (request: HTTPRequest) in
    return "wildcard: \(request.url)"
}

try server.start()
