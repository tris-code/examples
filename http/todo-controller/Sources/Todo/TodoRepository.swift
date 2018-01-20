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

public protocol TodoRepository: Service {
    func get() -> [Todo]
    func get(id: Int) -> Todo?
    func upsert(todo: Todo)
}

public final class InMemoryTodoRepository: TodoRepository {
    var todos: [Int: Todo] = [
        0: Todo(id: 0, done: false, description: "sleep sometimes")
    ]

    public init() {}

    public func get() -> [Todo] {
        return todos.values.sorted()
    }

    public func get(id: Int) -> Todo? {
        guard let todo = todos[id] else {
            return nil
        }
        return todo
    }

    public func upsert(todo: Todo) {
        todos[todo.id] = todo
    }
}
