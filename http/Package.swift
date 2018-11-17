// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "http-example",
    dependencies: [
        .package(
            url: "https://github.com/tris-foundation/http.git",
            .branch("master")),
        .package(
            url: "https://github.com/tris-foundation/fiber.git",
            .branch("master"))
    ],
    targets: [
        .target(
            name: "main",
            dependencies: ["HTTP", "Fiber"])
    ]
)
