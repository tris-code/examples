import PackageDescription

let package = Package(
    name: "SocketExample",
    dependencies: [
        .Package(url: "https://github.com/tris-foundation/socket.git", majorVersion: 0),
        .Package(url: "https://github.com/tris-foundation/async-dispatch.git", majorVersion: 0),
        .Package(url: "https://github.com/tris-foundation/fiber.git", majorVersion: 0)
    ]
)
