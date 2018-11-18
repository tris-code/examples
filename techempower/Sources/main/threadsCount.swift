import Platform

var threadsCount: Int {
    if CommandLine.arguments.count == 2,
        let count = Int(CommandLine.arguments[1]) {
        guard count >= 1 else {
            print("threads count should be >= 1")
            exit(1)
        }
        return count - 1
    } else {
        return CPU.count - 1
    }
}
