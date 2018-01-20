/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

import HTTP

public final class TodoController: Controller, InjectService {
    let repository: TodoRepository

    public init(_ repository: TodoRepository) {
        self.repository = repository
    }

    public static func setup(router: ControllerRouter<TodoController>) throws {
        router.route(get: "/todos", handler: get)
        router.route(get: "/todos/:integer", handler: getById)
        router.route(post: "/todos", handler: add)
        router.route(put: "/todos/:integer", handler: update)
    }

    func get() -> [Todo] {
        return repository.get()
    }

    func getById(_ id: Int) throws -> Todo {
        guard let todo = repository.get(id: id) else {
            throw HTTP.Error.notFound
        }
        return todo
    }

    func add(todo: Todo) throws -> Todo {
        guard repository.get(id: todo.id) == nil else {
            throw HTTP.Error.conflict
        }
        repository.upsert(todo: todo)
        return todo
    }

    func update(todo: Todo) throws -> Todo {
        guard let _ = repository.get(id: todo.id) else {
            throw HTTP.Error.notFound
        }
        repository.upsert(todo: todo)
        return todo
    }
}
