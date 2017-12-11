// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "tarantool-module-example",
    products: [
        .library(
            name: "swift_tarantool_module",
            type: .dynamic,
            targets: ["module"])
    ],
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
            name: "module",
            dependencies: ["TarantoolModule", "AsyncTarantool"]),
        .target(
            name: "connector",
            dependencies: ["TarantoolConnector", "AsyncFiber"])
    ]
)
