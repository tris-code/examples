// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "spa-nginx-example",
    dependencies: [
        .package(
            url: "https://github.com/tris-foundation/platform.git",
            from: "0.4.0"
        ),
        .package(
            url: "https://github.com/tris-foundation/http.git",
            from: "0.4.0"
        ),
        .package(
            url: "https://github.com/tris-foundation/async-dispatch.git",
            from: "0.4.0"
        ),
        .package(
            url: "https://github.com/tris-foundation/fiber.git",
            from: "0.4.0"
        ),
        .package(
            url: "https://github.com/tris-foundation/log.git",
            from: "0.4.0"
        )
    ],
    targets: [
        .target(
            name: "main",
            dependencies: [
                "Log",
                "Server",
                "Fiber",
                "AsyncFiber",
                "AsyncDispatch"
            ]
        )
    ]
)
