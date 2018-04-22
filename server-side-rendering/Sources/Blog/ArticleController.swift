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

public final class ArticleController: Controller, InjectService {
    let repository: ArticleRepository

    public init(_ repository: ArticleRepository) {
        self.repository = repository
    }

    public static func setup(router: Router<ArticleController>) throws {
        router.route(get: "/article", to: get)
        router.route(get: "/article/:integer", to: getById)

        router.route(post: "/article", authorizing: .claim("admin"), to: add)
        router.route(put: "/article/:integer", authorizing: .claim("admin"), to: update)
    }

    func get() -> [Article] {
        return repository.get()
    }

    func getById(_ id: Int) throws -> Article {
        guard let article = repository.get(id: id) else {
            throw HTTP.Error.notFound
        }
        return article
    }

    func add(article: NewArticle) throws -> Int {
        let article = repository.add(article)
        return article.id
    }

    func update(article: Article) throws -> Article {
        guard let _ = repository.get(id: article.id) else {
            throw HTTP.Error.notFound
        }
        repository.update(article)
        return article
    }
}
