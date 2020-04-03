import Web
import UUID

fileprivate var users: [User] = []

public final class InMemoryUserRepository: UserRepository, Inject {
    public init() {
        _ = add(user: User(
            name: "Admin",
            email: "admin",
            password: "admin",
            claims: ["admin"]))
    }

    public func get(id: String) -> User? {
        return users.first(where: { $0.id == id })
    }

    public func add(user: User) -> String {
        var user = user
        user.id = UUID().uuidString
        users.append(user)
        return user.id!
    }

    public func find(email: String) -> User? {
        return users.first(where: { $0.email == email })
    }
}
