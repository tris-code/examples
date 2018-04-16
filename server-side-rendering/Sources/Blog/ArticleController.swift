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
