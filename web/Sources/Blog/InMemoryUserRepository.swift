/******************************************************************************
 *                                                                            *
 * Tris Foundation disclaims copyright to this source code.                   *
 * In place of a legal notice, here is a blessing:                            *
 *                                                                            *
 *     May you do good and not evil.                                          *
 *     May you find forgiveness for yourself and forgive others.              *
 *     May you share freely, never taking more than you give.                 *
 *                                                                            *
 ******************************************************************************/

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
