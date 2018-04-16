/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

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
