import Async
import Stream
import Network

struct BinaryMessage: Equatable {
    let code: Int
    let message: String
    let data: [UInt8]
}

extension BinaryMessage {
    init<T: StreamReader>(from stream: inout T) throws {
        self.code = try stream.read(Int.self)

        let messageLength = try stream.read(Int.self)
        self.message = try stream.read(count: messageLength, as: String.self)

        let dataLength = try stream.read(Int.self)
        self.data = try stream.read(count: dataLength, as: [UInt8].self)
    }

    func encode<T: StreamWriter>(to stream: inout T) throws {
        try stream.write(code)

        let messageBytes = [UInt8](message.utf8)
        try stream.write(messageBytes.count)
        try stream.write(messageBytes)

        try stream.write(data.count)
        try stream.write(data)
    }
}

class BinaryProtocol {
    let host: String
    let port: Int

    init(at host: String, port: Int) {
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
                var stream = BufferedStream(
                    baseStream: NetworkStream(socket: client),
                    capacity: 4096)

                while true {
                    do {
                        let message = try BinaryMessage(from: &stream)
                        try message.encode(to: &stream)
                        try stream.flush()
                    } catch let error as StreamError
                        where error == .insufficientData {
                        // connection closed
                        return
                    }
                }
            } catch {
                print("error: \(error)")
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

                var stream = BufferedStream(
                    baseStream: NetworkStream(socket: server),
                    capacity: 4096)

                try message.encode(to: &stream)
                try stream.flush()

                let reply = try BinaryMessage(from: &stream)
                guard reply == message else {
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
