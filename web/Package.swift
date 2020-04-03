// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "blog",
    products: [
        .executable(name: "blog", targets: ["main"])
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
