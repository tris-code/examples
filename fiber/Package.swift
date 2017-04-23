import PackageDescription

let package = Package(
    name: "example",
    dependencies: [
        .Package(url: "https://github.com/tris-foundation/fiber.git", majorVersion: 0)
    ]
)
