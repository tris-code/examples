// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "tarantool-module-http-example",
    products: [
        .library(name: "module", type: .dynamic, targets: ["HTTPServerModule"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/tris-foundation/http.git",
            from: "0.4.0"
        ),
        .package(
            url: "https://github.com/tris-foundation/messagepack.git",
            from: "0.4.0"
        ),
        .package(
            url: "https://github.com/tris-foundation/tarantool.git",
            from: "0.4.0"
        ),
        .package(
            url: "https://github.com/tris-foundation/log.git",
            from: "0.4.0"
        )
    ],
    targets: [
        .target(
            name: "HTTPServerModule",
            dependencies: ["Server", "AsyncTarantool", "TarantoolModule", "Log"]
        )
    ]
)
