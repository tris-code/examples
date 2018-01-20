/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

public struct Todo: Codable, Equatable {
    public let id: Int
    public var done: Bool
    public var description: String

    public init(id: Int, done: Bool, description: String) {
        self.id = id
        self.done = done
        self.description = description
    }
}

extension Todo: Comparable {
    public static func < (lhs: Todo, rhs: Todo) -> Bool {
        return lhs.id < rhs.id
    }
}
