import Fiber
import Socket
import Dispatch
import Foundation
import AsyncFiber
import AsyncDispatch

// you can also use AsyncDispatch fallback
// see the first README.md commit to get the idea

let async = AsyncFiber()

let hello = [UInt8]("Hello, World!".utf8)

async.task {
    do {
        let socket = try Socket(awaiter: async.awaiter)
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
        let socket = try Socket(awaiter: async.awaiter)
            .connect(to: "127.0.0.1", port: 1111)

        var buffer = [UInt8](repeating: 0, count: hello.count + 1)
        _ = try socket.receive(to: &buffer)

        print("tcp: \(String(cString: buffer))")
    } catch {
        print("tcp client socket error \(error)")
    }
}


let udpServerAddress = try Socket.Address("127.0.0.1", port: 2222)
let udpClientAddress = try Socket.Address("127.0.0.1", port: 3333)

async.task {
    do {
        let socket = try Socket(type: .datagram, awaiter: async.awaiter)
            .bind(to: udpServerAddress)

        _ = try socket.send(bytes: hello, to: udpClientAddress)
    } catch {
        print("udp server socket error \(error)")
    }
}

async.task {
    do {
        let socket = try Socket(type: .datagram, awaiter: async.awaiter)
            .bind(to: udpClientAddress)

        var buffer = [UInt8](repeating: 0, count: hello.count + 1)
        _ = try socket.receive(to: &buffer, from: udpServerAddress)

        print("udp: \(String(cString: buffer))")
    } catch {
        print("udp client socket error \(error)")
    }
}

async.task {
    do {
        let socket = try Socket(family: .inet6, awaiter: async.awaiter)
            .bind(to: "::1", port: 4444)
            .listen()

        let client = try socket.accept()
        _ = try client.send(bytes: hello)
    } catch {
        print("ip6 server socket error \(error)")
    }
}

async.task {
    do {
        let socket = try Socket(family: .inet6, awaiter: async.awaiter)
            .connect(to: "::1", port: 4444)

        var buffer = [UInt8](repeating: 0, count: hello.count + 1)
        _ = try socket.receive(to: &buffer)

        print("ip6: \(String(cString: buffer))")
    } catch {
        print("ip6 client socket error \(error)")
    }
}


#if os(Linux)
let type: Socket.SocketType = .sequenced
#else
let type: Socket.SocketType = .stream
#endif

unlink("/tmp/socketexample.sock")

async.task {
    do {
        let socket = try Socket(family: .unix, type: type, awaiter: async.awaiter)
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
        let socket = try Socket(family: .unix, type: type, awaiter: async.awaiter)
            .connect(to: "/tmp/socketexample.sock")

        var buffer = [UInt8](repeating: 0, count: hello.count + 1)
        _ = try socket.receive(to: &buffer)

        print("unix: \(String(cString: buffer))")
    } catch {
        print("unix client socket error \(error)")
    }
}

async.task {
    sleep(until: Date().addingTimeInterval(0.01))
    exit(0)
}

async.loop.run()
