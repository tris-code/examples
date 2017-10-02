import AsyncDispatch
import AsyncFiber
import Foundation

// you can also use AsyncDispatch shim for test purposes
// see the first README.md commit to get the idea

AsyncDispatch().registerGlobal()

try socketExample()


async.loop.run()
