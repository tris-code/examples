import Platform
import Foundation

var threadsCount: Int {
    if ProcessInfo.processInfo.arguments.count == 2,
        let count = Int(ProcessInfo.processInfo.arguments[1]) {
        guard count >= 1 else {
            print("thread count should be >= 1")
            exit(1)
        }
        return count - 1
    } else {
        return ProcessInfo.processInfo.activeProcessorCount - 1
    }
}
