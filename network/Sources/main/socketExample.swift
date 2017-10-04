import Network
import Dispatch
import AsyncFiber

let hello = [UInt8]("Hello, World!".utf8)
let empty = [UInt8](repeating: 0, count: hello.count + 1)

func socketExample() throws {
    async.task {
        do {
            let socket = try Socket()
                .bind(to: "127.0.0.1", port: 1111)
                .listen()

            let client = try socket.accept()
            _ = try client.send(bytes: hello)
        } catch {
            print("tcp server socket error \(error)")
        }
    }

    async.task {
        do {
            let socket = try Socket()
                .connect(to: "127.0.0.1", port: 1111)

            var buffer = empty
            _ = try socket.receive(to: &buffer)

            print("tcp: \(String(cString: buffer))")
        } catch {
            print("tcp client socket error \(error)")
        }
    }


    let udpServerAddress = try Socket.Address("127.0.0.1", port: 2222)

    async.task {
        do {
            let socket = try Socket(type: .datagram)
                .bind(to: udpServerAddress)

            var buffer = empty
            var client: Socket.Address? = nil
            _ = try socket.receive(to: &buffer, from: &client)
            _ = try socket.send(bytes: hello, to: client!)
        } catch {
            print("udp server socket error \(error)")
        }
    }

    async.task {
        do {
            let socket = try Socket(type: .datagram)

            var buffer = empty
            _ = try socket.send(bytes: hello, to: udpServerAddress)
            _ = try socket.receive(to: &buffer)

            print("udp: \(String(cString: buffer))")
        } catch {
            print("udp client socket error \(error)")
        }
    }


    async.task {
        do {
            let socket = try Socket(family: .inet6)
                .bind(to: "::1", port: 3333)
                .listen()

            let client = try socket.accept()
            _ = try client.send(bytes: hello)
        } catch {
            print("ip6 server socket error \(error)")
        }
    }

    async.task {
        do {
            let socket = try Socket(family: .inet6)
                .connect(to: "::1", port: 3333)

            var buffer = empty
            _ = try socket.receive(to: &buffer)

            print("ip6: \(String(cString: buffer))")
        } catch {
            print("ip6 client socket error \(error)")
        }
    }


#if os(Linux)
    let type: Socket.`Type` = .sequenced
#else
    let type: Socket.`Type` = .stream
#endif

    unlink("/tmp/socketexample.sock")

    async.task {
        do {
            let socket = try Socket(family: .local, type: type)
                .bind(to: "/tmp/socketexample.sock")
                .listen()

            let client = try socket.accept()
            _ = try client.send(bytes: hello)
        } catch {
            print("unix server socket error \(error)")
        }
    }

    async.task {
        do {
            let socket = try Socket(family: .local, type: type)
                .connect(to: "/tmp/socketexample.sock")

            var buffer = empty
            _ = try socket.receive(to: &buffer)

            print("unix: \(String(cString: buffer))")
        } catch {
            print("unix client socket error \(error)")
        }
    }
}
