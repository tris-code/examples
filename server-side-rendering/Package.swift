// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "blog",
    dependencies: [
        .package(
            url: "https://github.com/tris-foundation/web.git",
            .branch("master")),
        .package(
            url: "https://github.com/tris-foundation/ssr.git",
            .branch("master")),
        .package(
            url: "https://github.com/tris-foundation/fiber.git",
            .branch("master"))
    ],
    targets: [
        .target(
            name: "Blog",
            dependencies: ["Web"]
        ),
        .target(
            name: "main",
            dependencies: ["Blog", "Web", "SSR", "Fiber"]
        )
    ]
)
