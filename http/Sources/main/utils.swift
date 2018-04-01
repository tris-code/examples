import Platform

func trycatch(_ task: () throws -> Void) {
    do {
        try task()
    } catch {
        print(error)
        exit(1)
    }
}
