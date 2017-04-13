import Async
import Client
import Foundation

func print(_ request: (Void) throws -> Response) {
    do {
        let response = try request()
        Swift.print(response.body ?? "empty response")
        Swift.print("")
    } catch {
        print(error)
    }
}

func runClient(async: Async) throws {
    async.task {
        do {
            let client = try Client(async: async)
            try client.connect(to: "http://0.0.0.0:8080")

            print {
                try client.get("/hello")
            }

            print {
                try client.get("/hello/username")
            }

            print {
                try client.get("/robot/8")
            }

            print {
                try client.get("/page/news?skip=2")
            }

            print {
                try client.post("/todo", json: [
                    "name": "sleep sometimes",
                    "done": false
                ])
            }

            print {
                try client.post("/todo/post", json: ["done": true])
            }

            print {
                try client.get("/todo/as/json")
            }

            print {
                try client.get("/request")
            }

            print {
                try client.get("/whatdoesmarcelluswallacelooklike")
            }

            exit(0)
        } catch {
            print(error)
            exit(1)
        }
    }
}
