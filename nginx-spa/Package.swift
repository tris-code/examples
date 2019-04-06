// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "spa-nginx",
    dependencies: [
        .package(
            url: "https://github.com/tris-code/http.git",
            .branch("master")),
        .package(
            url: "https://github.com/tris-code/fiber.git",
            .branch("master")),
        .package(
            url: "https://github.com/tris-code/log.git",
            .branch("master"))
    ],
    targets: [
        .target(
            name: "main",
            dependencies: [
                "Log",
                "HTTP",
                "Fiber"
            ]
        )
    ]
)
