// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "network-example",
    dependencies: [
        .package(
            url: "https://github.com/tris-code/network.git",
            .branch("master")),
        .package(
            url: "https://github.com/tris-code/fiber.git",
            .branch("master"))
    ],
    targets: [
        .target(
            name: "main",
            dependencies: [
                "Fiber",
                "Network"
            ]
        )
    ]
)
