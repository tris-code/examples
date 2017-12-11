// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "http-example",
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
                "Server",
                "Client",
                "Fiber",
                "AsyncFiber",
                "AsyncDispatch"
            ]
        )
    ]
)
