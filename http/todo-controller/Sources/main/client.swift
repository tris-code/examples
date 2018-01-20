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

func print(_ request: () throws -> Response) {
    do {
        let response = try request()
        Swift.print(response.string ?? "empty response")
        Swift.print("")
    } catch {
        print(error)
    }
}

func runClient() throws {
    let client = Client(host: "127.0.0.1", port: 8080)

    print()

    print {
        try client.get(path: "/todos")
    }

    print {
        try client.post(
            path: "/todos",
            object: Todo(id: 1, done: true, description: "add new todo"))
    }

    print {
        try client.get(path: "/todos")
    }
}
