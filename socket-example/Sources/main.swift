import Foundation
import Dispatch
import Socket

let hey = [UInt8]("hey there!".utf8)

DispatchQueue.global().async {
    do {
        let socket = try Socket()
        try socket.listen(at: "127.0.0.1", port: 7654)
        while true {
            let client = try socket.accept()
            let written = try client.write(bytes: hey)
        }
    } catch {
        print("server socket error")
    }
}

DispatchQueue.global().async {
    do {
        let socket = try Socket()
        try socket.connect(to: "127.0.0.1", port: 7654)

        var buffer = [UInt8](repeating: 0, count: 100)
        let read = try socket.read(to: &buffer)

        print(String(cString: buffer))
        exit(0)
    } catch {
        print("client socket error")
    }
}

RunLoop.main.run()
