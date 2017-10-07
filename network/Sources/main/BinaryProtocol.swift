import Async
import Stream
import Network

struct BinaryMessage {
    let code: Int
    let message: String
    let data: [UInt8]
}

enum BinaryError: Error {
    case inputError
    case outputError
}

extension BinaryMessage {
    init<T: InputStream>(from stream: T) throws {
        self.code = try stream.read(Int.self)

        let messageLength = try stream.read(Int.self)
        var messageBytes = [UInt8](repeating: 0, count: messageLength)
        guard try stream.read(to: &messageBytes) == messageLength else {
            throw BinaryError.inputError
        }
        self.message = String(decoding: messageBytes, as: UTF8.self)

        let dataLength = try stream.read(Int.self)
        var data = [UInt8](repeating: 0, count: dataLength)
        guard try stream.read(to: &data) == dataLength else {
            throw BinaryError.inputError
        }
        self.data = data
    }

    func encode<T: OutputStream>(to stream: T) throws {
        try stream.write(code)

        let messageBytes = [UInt8](message.utf8)
        try stream.write(messageBytes.count)
        guard try stream.write(messageBytes) == messageBytes.count else {
            throw BinaryError.outputError
        }

        try stream.write(data.count)
        guard try stream.write(data) == data.count else {
            throw BinaryError.outputError
        }
    }

    func reversed() -> BinaryMessage {
        return BinaryMessage(
            code: ~code,
            message: String(message.reversed()),
            data: data.reversed())
    }
}

class BinaryProtocol {
    let host: String
    let port: UInt16

    init(at host: String, port: UInt16) {
        self.host = host
        self.port = port
    }

    func run() {
        async.task {
            do {
                let socket = try Socket()
                    .bind(to: self.host, port: self.port)
                    .listen()

                while true {
                    let client = try socket.accept()
                    self.handleClient(client)
                }
            } catch {
                print("echo server error: \(error)")
            }
        }
    }

    func handleClient(_ client: Socket) {
        async.task {
            do {
                let stream = BufferedStream(
                    stream: NetworkStream(socket: client),
                    capacity: 4096
                )

                while true {
                    do {
                        let message = try BinaryMessage(from: stream)
                        try message.reversed().encode(to: stream)
                        try stream.flush()
                    } catch where error is NetworkStream.Error {
                        // connection closed
                        return
                    }
                }
            } catch {
                print("binary reply error: \(error)")
            }
        }
    }

    func ping() {
        async.task {
            do {
                let message = BinaryMessage(
                    code: 42,
                    message: "Hello",
                    data: [1,2,3,4,5])

                let server = try Socket()
                    .connect(to: self.host, port: self.port)

                let stream = BufferedStream(
                    stream: NetworkStream(socket: server),
                    capacity: 4096
                )

                try message.encode(to: stream)
                try stream.flush()

                let reply = try BinaryMessage(from: stream)
                guard reply.code == ~message.code,
                    reply.message == String(message.message.reversed()),
                    reply.data == message.data.reversed() else {
                        print("binary protocol: invalid reply")
                        return
                }
                print("binary protocol reply: \(reply)")
            } catch {
                print("ping error: \(error)")
            }
        }
    }
}
