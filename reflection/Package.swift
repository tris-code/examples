import PackageDescription

let package = Package(
    name: "example",
    dependencies: [
        .Package(url: "https://github.com/tris-foundation/reflection.git", majorVersion: 0, minor: 3)
    ]
)
