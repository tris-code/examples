import Log
import Async
import Fiber
import Platform

// Fiber - cooperative multitasking,
// runs new fiber for each connection

// Tarantool - cooperative multitasking,
// runs on tarantool's implementation of fibers + evloop,
// you can find an example in tarantool-module-http-server
// import TarantoolModule; async.use(Tarantool.self)

// Dispatch - preemptive multitasking,
// spawns Dispatch task for each connection
// NOTE: for test purposes only,
// import AsyncDispatch; async.use(Dispatch.self)

async.use(Fiber.self)

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
