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
                try client.get("/user/8")
            }

            print {
                try client.get("/todos")
            }

            struct Todo: Encodable {
                let name: String
                let done: Bool
            }

            print {
                try client.post("/todo", json: Todo(
                    name: "sleep sometimes (from json)",
                    done: false))
            }

            print {
                try client.post("/todo", urlEncoded: Todo(
                    name: "sleep sometimes (from urlencoded)",
                    done: false))
            }

            struct Event: Encodable {
                let name: String
            }

            print {
                try client.post("/date/May/8", json: Event(name: "Dance"))
            }

            print {
                try client.get("/whatdoesmarcelluswallacelooklike")
            }
        } catch {
            print(error)
            exit(1)
        }
    }
}
