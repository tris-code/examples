// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "tarantool-module-example",
    products: [
        .library(name: "module", type: .dynamic, targets: ["module"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/tris-foundation/tarantool.git",
            from: "0.4.0"
        )
    ],
    targets: [
        .target(name: "module", dependencies: ["TarantoolModule"]),
        .target(name: "connector", dependencies: ["TarantoolConnector"])
    ]
)
