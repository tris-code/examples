import Time
import Fiber
import Foundation

// Transfer execution

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

// Channels

var channel = Channel<Int>()

fiber {
    while let value = channel.read() {
        print("read: \(value)")
    }
    print("read: the channel is closed.")
}

fiber {
    for i in 0..<5 {
        channel.write(i)
    }
    channel.close()
}

// Sleep

let now: Time = .now

fiber {
    fiber {
        sleep(until: now + 2.s)
        print("fiber 2 woke up")
    }
    sleep(until: now + 1.s)
    print("fiber 1 woke up")
}

// Activity indicator

fiber {
    for _ in 0..<300 {
        print(".", terminator: "")
        sleep(until: .now + 10.ms)
    }
    print("3 sec timeout")
}

FiberLoop.main.run()
