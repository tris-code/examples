import PackageDescription

let package = Package(
    name: "fiber",
    dependencies: [
        .Package(url: "https://github.com/tris-foundation/fiber.git", majorVersion: 0)
    ]
)
