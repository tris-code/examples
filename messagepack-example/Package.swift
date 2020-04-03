// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "messagepack-example",
    products: [
        .executable(name: "messagepack-example", targets: ["main"])
    ],
    dependencies: [
        .package(path: "../../messagepack")
    ],
    targets: [
        .target(name: "main", dependencies: ["MessagePack"])
    ]
)
