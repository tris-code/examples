// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "web-example",
    products: [
        .executable(name: "web-example", targets: ["main"])
    ],
    dependencies: [
        .package(path: "../../web"),
        .package(path: "../../fiber"),
        .package(path: "../../crypto"),
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
