import PackageDescription

let package = Package(
    name: "SocketExample",
    dependencies: [
        .Package(url: "https://github.com/tris-foundation/socket.git", majorVersion: 0)
    ]
)
