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
import HTTP
import SSR
import Web
import struct Foundation.URL

class BlogBootstrap: Bootstrap {
    let path: Path

    init() {
        let root = URL(fileURLWithPath: #file)
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .deletingLastPathComponent()
            .appendingPathComponent("Web")
            .path
        self.path = Path(root: root, www: "www")
    }

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

    func configure(application: HTTP.Application) throws {
        application.serveStaticFiles(
            from: "\(path)",
            including: [
                "/build/*", "/build/*/*",
                "/assets/*", "/assets/*/*",
                "/profile/*", "/profile/*/*"
            ])
    }

    func configure(router: HTTP.Router) throws {
        let renderer = try RiotRenderer(path: path, handler: router.process)
        try router.addServerSideRendering(renderer: renderer)
    }
}
