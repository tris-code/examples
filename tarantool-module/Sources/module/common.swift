import TarantoolModule

let schema = try! Schema(Box())

struct ModuleError: Error, CustomStringConvertible {
    let description: String
}
