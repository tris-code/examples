// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "network-example",
    dependencies: [
        .package(
            url: "https://github.com/tris-foundation/network.git",
            from: "0.4.0"
        ),
        .package(
            url: "https://github.com/tris-foundation/async-dispatch.git",
            from: "0.4.0"
        ),
        .package(
            url: "https://github.com/tris-foundation/fiber.git",
            from: "0.4.0"
        )
    ],
    targets: [
        .target(
            name: "main",
            dependencies: [
                "Fiber",
                "Network",
                "AsyncFiber",
                "AsyncDispatch",
            ]
        )
    ]
)
