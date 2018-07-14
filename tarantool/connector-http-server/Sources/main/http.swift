import HTTP
import TarantoolConnector

// Configuration

func configureServer(_ server: Server) {
    let applicationV1 = Application(basePath: "/api/v1", middleware: [])

    applicationV1.route(post: "/registration", to: registrationHandler)

    server.addApplication(applicationV1)
}

// Logic

struct Credentials: Decodable {
    let email: String
    let password: String
}

struct RegistrationResponse: Encodable {
    let userId: String

    enum CondingKeys: String, CodingKey {
        case userId = "UserID"
    }
}

func registrationHandler(user: Credentials) -> RegistrationResponse {
    // TODO: tarantool connect
    return RegistrationResponse(userId: "1")
}
