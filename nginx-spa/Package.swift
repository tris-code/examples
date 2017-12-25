// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "spa-nginx-example",
    dependencies: [
        .package(
            url: "https://github.com/tris-foundation/http.git",
            .branch("master")),
        .package(
            url: "https://github.com/tris-foundation/fiber.git",
            .branch("master")),
        .package(
            url: "https://github.com/tris-foundation/log.git",
            .branch("master"))
    ],
    targets: [
        .target(
            name: "main",
            dependencies: [
                "Log",
                "HTTP",
                "AsyncFiber"
            ]
        )
    ]
)
