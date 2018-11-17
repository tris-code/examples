import HTTP

/// Routes used in QuickStart section in our documentation

func registerQuickStartRoutes(in server: Server) {
    registerV0Routes(in: server)
    registerV1Routes(in: server)
    registerV2Routes(in: server)
    registerV3Routes(in: server)
}

// MARK: Simple

func registerV0Routes(in server: Server) {
    server.route(get: "/hello") {
        return "Hey there!"
    }
}

// MARK: More Advanced

func registerV1Routes(in server: Server) {
    struct User: Decodable {
        let name: String
    }

    func helloHandler(user: User) -> String {
        return "Hello, \(user.name)!"
    }

    let application = Application(basePath: "/v1")
    application.route(get: "/hello", to: helloHandler)
    server.addApplication(application)
}

// MARK: Most Advanced

func registerV2Routes(in server: Server) {
    struct User: Decodable {
        let name: String
    }

    struct Greeting: Encodable {
        let message: String
    }

    func helloHandler(user: User) -> Greeting {
        return .init(message: "Hello, \(user.name)!")
    }

    struct SwiftMiddleware: Middleware {
        static func chain(
            with handler: @escaping RequestHandler) -> RequestHandler
        {
            return { request in
                if request.url.query?["name"] == "swift" {
                    return Response(string: "🤘")
                }
                return try handler(request)
            }
        }
    }

    let application = Application(basePath: "/v2")

    application.route(
        get: "/hello",
        through: [SwiftMiddleware.self],
        to: helloHandler)

    server.addApplication(application)
}

// MARK: Most Advanced (Human Readable URL)

func registerV3Routes(in server: Server) {
    struct User: Decodable {
        let name: String
    }

    struct Greeting: Encodable {
        let message: String
    }

    func helloHandler(user: User) -> Greeting {
        return .init(message: "Hello, \(user.name)!")
    }

    struct SwiftMiddleware: Middleware {
        static func chain(
            with handler: @escaping RequestHandler) -> RequestHandler
        {
            return { request in
                if request.url.path.split(separator: "/").last == "swift" {
                    return Response(string: "🤘")
                }
                return try handler(request)
            }
        }
    }

    let application = Application(basePath: "/v3")

    application.route(
        get: "/hello/:name",
        through: [SwiftMiddleware.self],
        to: helloHandler)

    server.addApplication(application)
}
