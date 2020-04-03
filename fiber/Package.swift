// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "fiber-example",
    products: [
        .executable(name: "fiber-example", targets: ["main"])
    ],
    dependencies: [
        .package(path: "../../Fiber")
    ],
    targets: [
        .target(name: "main", dependencies: ["Fiber"])
    ]
)
