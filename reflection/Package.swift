import PackageDescription

let package = Package(
    name: "reflection",
    dependencies: [
        .Package(url: "https://github.com/tris-foundation/reflection.git", majorVersion: 0)
    ]
)
