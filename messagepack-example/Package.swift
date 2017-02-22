// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "example",
    dependencies: [
        .Package(url: "https://github.com/tris-foundation/messagepack.git", majorVersion: 0)
    ]
)
