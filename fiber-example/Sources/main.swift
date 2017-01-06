import Fiber
import Foundation

fiber {
    print("hello from fiber 1")
    fiber {
        print("hello from fiber 2")
        yield()
        print("bye from fiber 2")
    }
    print("no, you first")
    yield()
    print("bye from fiber 1")
}

let now = Date()

fiber {
    fiber {
        sleep(until: now.addingTimeInterval(2))
        print("fiber 2 woke up")
    }
    sleep(until: now.addingTimeInterval(1))
    print("fiber 1 woke up")
}

fiber {
    while true {
        print(".", terminator: "")
        sleep(until: Date().addingTimeInterval(0.01))
    }
}

FiberLoop.main.run(until: Date().addingTimeInterval(5))
