/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

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
