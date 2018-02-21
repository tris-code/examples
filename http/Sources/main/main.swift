import Log
import Platform
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

async.task {
    do {
        try runServer()
    } catch {
        print(String(describing: error))
        exit(1)
    }
}

async.task {
    do {
        try runClient()
    } catch {
        print(String(describing: error))
        exit(1)
    }
}

async.loop.run()
