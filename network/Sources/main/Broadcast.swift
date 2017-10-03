import Async
import Network

class Broadcast {
    let host: String
    let port: UInt16

    init(at host: String, port: UInt16) {
        self.host = host
        self.port = port
    }

    func run() {
        async.task {
            do {
                let socket = try Socket(type: .datagram)
                    .bind(to: self.host, port: self.port)

                while true {
                    var buffer = [UInt8](repeating: 0, count: 1024)
                    var client: Socket.Address? = nil
                    let read = try socket.receive(to: &buffer, from: &client)
                    guard read > 0 else {
                        continue
                    }
                    let message = String(
                        decoding: buffer[..<read],
                        as: UTF8.self)
                    let whom = client?.description ?? "unknown"
                    print("broadcast message from \(whom): \(message)")

                }
            } catch {
                print("echo server error: \(error)")
            }
        }
    }

    func send() {
        async.task {
            do {
                let message = [UInt8]("Hello".utf8)

                let client = try Socket(type: .datagram).configure { options in
                    options.broadcast = true
                }

                let address = try Socket.Address(
                    "255.255.255.255",port: self.port)

                guard try client.send(bytes: message, to: address) > 0 else {
                    fatalError("can't send broadcast message")
                }
            } catch {
                print("broadcast error: \(error)")
            }
        }
    }
}
