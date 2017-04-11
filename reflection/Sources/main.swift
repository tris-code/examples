import Reflection

struct Person {
    let name: String
    let age: Int
}


let blueprint = Blueprint(of: Person.self)

// Strict type
let values: [String : Any] = ["name" : "Tony", "age": 16]
let tony = blueprint.construct(using: values) // ok
let tonyClone = blueprint.construct(using: values, shouldConvert: false) // ok

// Parse string values
let stringValues = ["name" : "Tony", "age" : "16"]
let tonyConverted = blueprint.construct(using: stringValues) // ok
let tonyNil = blueprint.construct(using: stringValues, shouldConvert: false) // nil

// Nested struct
struct User {
    let username: String
    let person: Person
}
let userBlueprint = Blueprint(of: User.self)
let userValues: [String : Any] = [
    "username" : "tonyfreeman",
    "person" : [
        "name" : "Tony",
        "age" : "16"
    ]
]
let tonyUser = userBlueprint.construct(using: userValues) // ok


print("tony: \(tony as Any)")
print("tonyClone: \(tonyClone as Any)")
print("tonyConverted: \(tonyConverted as Any)")
print("tonyNil: \(tonyNil as Any)")
print("tonyUser: \(tonyUser as Any)")

print("fields:")
let metadata = Metadata(of: User.self)
for fieldType in metadata.fieldTypes {
    print(fieldType)
}

if metadata.kind == .struct {
    print("surprise")
}
