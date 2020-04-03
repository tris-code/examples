// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "techempower",
    products: [
        .executable(name: "techempower", targets: ["main"])
    ],
    dependencies: [
        .package(path: "../../platform"),
        .package(path: "../../hTTP"),
        .package(path: "../../fiber"),
        .package(path: "../../log"),
    ],
    targets: [
        .target(
            name: "main",
            dependencies: [
                "Log",
                "HTTP",
                "Fiber",
                "Platform"
            ]
        )
    ]
)
