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

import Blog
import Web

class BlogBootstrap: Bootstrap {
    func configure(services: Services) throws {
        try services.register(
            singleton: InMemoryArticleRepository.self,
            as: ArticleRepository.self)
    }

    func configure(application: MVC.Application) throws {
        try application.addAuthorization(
            userRepository: InMemoryUserRepository.self,
            cookiesRepository: InMemoryCookiesStorage.self)

        try application.addController(ArticleController.self)
    }
}
