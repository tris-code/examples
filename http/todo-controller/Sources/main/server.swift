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
import Todo

func runServer() throws {
    let server = try Server(host: "127.0.0.1", port: 8080)

    try Services.shared.register(
        singleton: InMemoryTodoRepository.self,
        as: TodoRepository.self)

    try server.addController(TodoController.self)

    try server.start()
}
