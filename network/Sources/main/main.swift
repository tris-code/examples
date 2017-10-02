import AsyncDispatch
import AsyncFiber
import Foundation

// you can also use AsyncDispatch shim for test purposes
// see the first README.md commit to get the idea

AsyncDispatch().registerGlobal()

try socketExample()

// $ telnet 127.0.0.1 4000
try echoServer(at: "127.0.0.1", port: 4000)

async.loop.run()
