import Log
import AsyncFiber
import AsyncDispatch

// AsyncFiber - cooperative multitasking,
// runs new fiber for each connection

// AsyncTarantool - cooperative multitasking,
// runs on tarantool's implementation of fibers + evloop,
// you can find an example in tarantool-module-http-server

// AsyncDispatch - preemptive multitasking,
// spawns Dispatch task for each connection
// NOTE: for test purposes only

AsyncFiber().registerGlobal()

try runServer()
try runClient()

async.loop.run()
