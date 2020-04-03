// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "nginx-spa",
    products: [
        .executable(name: "nginx-spa", targets: ["main"])
    ],
    dependencies: [
        .package(path: "../../http"),
        .package(path: "../../fiber"),
        .package(path: "../../log"),
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
