import Async
import Client
import Foundation

func print(_ request: () throws -> Response) {
    do {
        let response = try request()
        Swift.print(response.body ?? "empty response")
        Swift.print("")
    } catch {
        print(error)
    }
}

func runClient() throws {
    let client = try Client(host: "0.0.0.0", port: 8080)

    print {
        try client.get(path: "/hello")
    }

    print {
        try client.get(path: "/привет")
    }

    print {
        try client.get(path: "/request")
    }

    print {
        try client.get(path: "/page/news")
    }

    print {
        try client.get(path: "/user/8")
    }

    print {
        try client.get(path: "/todos")
    }

    struct Todo: Encodable {
        let name: String
        let done: Bool

        init(type: String) {
            self.name = "sleep sometimes (transfer-encoding: \(type))"
            self.done = false
        }
    }

    print {
        try client.post(path: "/todo", object: Todo(type: "json"))
    }

    print {
        try client.post(
            path: "/todo",
            object: Todo(type: "url encoded"),
            contentType: .urlEncoded)
    }

    struct Event: Encodable {
        let name: String
    }

    print {
        try client.post(path: "/date/May/8", object: Event(name: "Dance"))
    }

    print {
        try client.get(path: "/whatdoesmarcelluswallacelooklike")
    }
}
