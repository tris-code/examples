/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

import Foundation

public struct Article: Codable, Equatable {
    public let id: Int
    public var title: String
    public var description: String

    public init(id: Int, title: String, description: String) {
        self.id = id
        self.title = title
        self.description = description
    }
}

public struct NewArticle: Codable, Equatable {
    public var title: String
    public var description: String

    public init(title: String, description: String) {
        self.title = title
        self.description = description
    }
}

extension Article: Comparable {
    public static func < (lhs: Article, rhs: Article) -> Bool {
        return lhs.id < rhs.id
    }
}
