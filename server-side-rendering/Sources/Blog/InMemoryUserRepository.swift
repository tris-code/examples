import Web
import struct Foundation.UUID

public final class InMemoryUserRepository: UserRepository, Inject {
    static var users: [User] = []

    public init() {
        _ = add(user: User(
            name: "Admin",
            email: "admin",
            password: "admin",
            claims: ["admin"]))
    }

    public func get(id: String) -> User? {
        return InMemoryUserRepository.users.first(where: { $0.id == id })
    }

    public func add(user: User) -> String {
        var user = user
        let id = UUID().uuidString
        user.id = id
        InMemoryUserRepository.users.append(user)
        return id
    }

    public func find(email: String) -> User? {
        return InMemoryUserRepository.users.first(where: { $0.email == email })
    }
}
