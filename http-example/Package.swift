// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "http-example",
    products: [
        .executable(name: "http-example", targets: ["main"])
    ],
    dependencies: [
        .package(path: "../../http"),
        .package(path: "../../fiber")
    ],
    targets: [
        .target(
            name: "main",
            dependencies: ["HTTP", "Fiber"])
    ]
)
