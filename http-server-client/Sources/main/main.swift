import Log
import AsyncFiber
import AsyncDispatch

Log.disabled = false // default is false

// AsyncDispatch - preemptive multitasking,
// spawns Dispatch task for each connection

// AsyncFiber - cooperative multitasking,
// runs new fiber for each connection

// AsyncTarantool - cooperative multitasking,
// runs on tarantool's implementation of fibers + evloop,
// not available in this example, see tarantool-module-http-server

let async = AsyncFiber()

try runServer(async: async)
try runClient(async: async)

async.loop.run()
