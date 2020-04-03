import HTTP

func makeRequests(using client: Client) throws {
    print(try client.get(path: "/ascii"))
    print(try client.get(path: "/юникод"))
    print(try client.get(path: "/request"))
    print(try client.get(path: "/swift/string/user"))
    print(try client.get(path: "/swift/int/42"))

    print(try client.get(path: "/decode-from-url/January/1"))
    print(try client.get(path: "/decode-json-or-form-urlencoded?name=push"))

    struct Event: Encodable {
        let name: String
    }

    print(try client.post(path: "/date/January/1", object: Event(name: "push")))

    print(try client.get(path: "/whatdoesmarcelluswallacelooklike"))

    print(try client.get(path: "/api/v1/test"))
}

func print(_ request: @autoclosure () throws -> Response) {
    do {
        let response = try request()
        Swift.print(response.string ?? "empty response")
        Swift.print("")
    } catch {
        print(error)
    }
}
