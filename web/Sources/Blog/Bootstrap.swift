import Web

public class BlogBootstrap: Bootstrap {
    public init() {}

    public func configure(services: Services) throws {
        try services.register(
            singleton: InMemoryArticleRepository.self,
            as: ArticleRepository.self)
    }

    public func configure(application: MVC.Application) throws {
        try application.addAuthorization(
            userRepository: InMemoryUserRepository.self,
            cookiesRepository: InMemoryCookiesStorage.self)

        try application.addController(ArticleController.self)
    }
}
