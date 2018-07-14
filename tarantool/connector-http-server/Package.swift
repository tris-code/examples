// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "connector-http-server",
    dependencies: [
        .package(
            url: "https://github.com/tris-foundation/tarantool.git",
            .branch("master")),
        .package(
            url: "https://github.com/tris-foundation/fiber.git",
            .branch("master")),
        .package(
            url: "https://github.com/tris-foundation/http.git",
            .branch("master"))
    ],
    targets: [
        .target(
            name: "main",
            dependencies: ["TarantoolConnector", "Fiber", "HTTP"])
    ]
)
