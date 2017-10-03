import AsyncFiber
import Foundation

// you can also use AsyncDispatch shim for test purposes
// see the first README.md commit to get the idea

AsyncFiber().registerGlobal()

try socketExample()

// $ telnet 127.0.0.1 4000
let echo = EchoServer(at: "127.0.0.1", port: 4000)
echo.run()

let binary = BinaryProtocol(at: "127.0.0.1", port: 4001)
binary.run()
binary.ping()

let broadcast = Broadcast(at: "0.0.0.0", port: 4002)
broadcast.run()
broadcast.send()

async.loop.run()
