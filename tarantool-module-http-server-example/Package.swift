/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

import PackageDescription

let package = Package(
    name: "TarantoolModuleHTTPServerExample",
    products: [
        .Library(name: "module", type: .dynamic, targets: ["TarantoolModuleHTTPServerExample"])
    ],
    dependencies: [
        .Package(url: "https://github.com/tris-foundation/http-server.git", majorVersion: 0),
        .Package(url: "https://github.com/tris-foundation/messagepack.git", majorVersion: 0),
        .Package(url: "https://github.com/tris-foundation/tarantool.git", majorVersion: 0),
    ]
)
