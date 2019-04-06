// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "blog",
    dependencies: [
        .package(
            url: "https://github.com/tris-code/web.git",
            .branch("master")),
        .package(
            url: "https://github.com/tris-code/fiber.git",
            .branch("master")),
        .package(
            url: "https://github.com/tris-code/crypto.git",
            .branch("master")),
    ],
    targets: [
        .target(
            name: "Blog",
            dependencies: ["Web", "UUID"]),
        .target(
            name: "main",
            dependencies: ["Blog", "Web", "Fiber"])
    ]
)
