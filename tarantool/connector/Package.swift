// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "tarantool-connector",
    dependencies: [
        .package(
            url: "https://github.com/tris-foundation/tarantool.git",
            .branch("master")),
        .package(
            url: "https://github.com/tris-foundation/fiber.git",
            .branch("master"))
    ],
    targets: [
        .target(
            name: "main",
            dependencies: ["TarantoolConnector", "AsyncFiber"])
    ]
)
