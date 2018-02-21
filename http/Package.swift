// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "http-server-client",
    dependencies: [
        .package(
            url: "https://github.com/tris-foundation/http.git",
            .branch("master")),
        .package(
            url: "https://github.com/tris-foundation/async.git",
            .branch("master")),
        .package(
            url: "https://github.com/tris-foundation/fiber.git",
            .branch("master"))
    ],
    targets: [
        .target(
            name: "main",
            dependencies: [
                "HTTP",
                "Fiber",
                "Async"
            ]
        )
    ]
)
