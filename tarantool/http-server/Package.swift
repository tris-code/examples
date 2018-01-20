// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "tarantool-module-http",
    products: [
        .library(name: "module", type: .dynamic, targets: ["HTTPServerModule"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/tris-foundation/http.git",
            .branch("master")),
        .package(
            url: "https://github.com/tris-foundation/messagepack.git",
            .branch("master")),
        .package(
            url: "https://github.com/tris-foundation/tarantool.git",
            .branch("master")),
        .package(
            url: "https://github.com/tris-foundation/log.git",
            .branch("master"))
    ],
    targets: [
        .target(
            name: "HTTPServerModule",
            dependencies: [
                "Log",
                "HTTP",
                "AsyncTarantool",
                "TarantoolModule",
                "MessagePack"
            ]
        )
    ]
)
