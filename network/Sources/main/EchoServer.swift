import Async
import Network

let welcome = [UInt8]("type 'exit' to close the connection\n".utf8)
let echoPrefix = [UInt8]("echo: ".utf8)

class EchoServer {
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
                _ = try client.send(bytes: welcome)

                func isExit(_ bytes: ArraySlice<UInt8>) -> Bool {
                    switch String(decoding: bytes, as: UTF8.self) {
                    case "exit\n": return true
                    case "exit\r\n": return true
                    default: return false
                    }
                }

                while true {
                    var buffer = [UInt8](repeating: 0, count: 1024)
                    let received = try client.receive(to: &buffer)
                    guard !isExit(buffer[..<received]) else {
                        break
                    }
                    let reply = echoPrefix + buffer.prefix(upTo: received)
                    var sent = 0
                    while sent < reply.count {
                        sent += try client.send(bytes: reply[sent...])
                    }
                }
            } catch {
                print("echo reply error: \(error)")
            }
        }
    }
}
