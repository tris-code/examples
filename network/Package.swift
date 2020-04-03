// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "network-example",
    products: [
        .executable(name: "network-example", targets: ["main"])
    ],
    dependencies: [
        .package(path: "../../network"),
        .package(path: "../../fiber")
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
