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
