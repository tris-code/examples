import Fiber
import Socket
import Dispatch
import Foundation
import AsyncFiber
import AsyncDispatch

let hey = [UInt8]("hey there!".utf8)

let async = AsyncFiber()

// see the initial commit to get the idea of AsyncDispatch
// let async = AsyncDispatch()

async.task {
    do {
        let socket = try Socket(awaiter: async.awaiter)
        try socket.listen(at: "127.0.0.1", port: 7654)
        while true {
            let client = try socket.accept()
            let written = try client.write(bytes: hey)
        }
    } catch {
        print("server socket error \(error)")
    }
}

async.task {
    do {
        for _ in 0..<10 {
            let socket = try Socket(awaiter: async.awaiter)
            try socket.connect(to: "127.0.0.1", port: 7654)

            var buffer = [UInt8](repeating: 0, count: 100)
            let read = try socket.read(to: &buffer)

            print(String(cString: buffer))
        }
        exit(0)
    } catch {
        print("client socket error \(error)")
    }
}

async.loop.run()
