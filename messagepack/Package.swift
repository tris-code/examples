// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "messagepack-example",
    dependencies: [
        .package(
            url: "https://github.com/tris-foundation/messagepack.git",
            .branch("master"))
    ],
    targets: [
        .target(name: "main", dependencies: ["MessagePack"])
    ]
)
