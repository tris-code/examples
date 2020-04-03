import Web

public protocol ArticleRepository: Inject {
    func get() -> [Article]
    func get(id: Int) -> Article?
    func add(_ article: NewArticle) -> Article
    func update(_ article: Article)
}

public final class InMemoryArticleRepository: ArticleRepository {
    static var articles: [Int: Article] = [
        0: Article(id: 0, title: "Post 1", description: "Swift hardcoded 1"),
        1: Article(id: 1, title: "Post 2", description: "Swift hardcoded 2")
    ]

    public init() {
    }

    public func get() -> [Article] {
        return InMemoryArticleRepository.articles.values.sorted()
    }

    public func get(id: Int) -> Article? {
        guard let article = InMemoryArticleRepository.articles[id] else {
            return nil
        }
        return article
    }

    public func add(_ new: NewArticle) -> Article {
        let id = InMemoryArticleRepository.articles.keys.max() ?? 0
        let article = Article(
            id: id, title:
            new.title,
            description: new.description)
        InMemoryArticleRepository.articles[id] = article
        return article
    }

    public func update(_ article: Article) {
        InMemoryArticleRepository.articles[article.id] = article
    }
}
