import Reflection

struct User {
    let name: String
    let age: Int
}

let blueprint = Blueprint(ofType: User.self)

let values: [String : Any] = ["name" : "Tony", "age": 7]
let tony = blueprint.construct(using: values, shouldConvert: false) // ok

let stringValues = ["name" : "Tony", "age" : "7"]
let tonyConverted = blueprint.construct(using: stringValues) // ok, parses strings by default
let tonyNil = blueprint.construct(using: stringValues, shouldConvert: false) // fails

print(tony as Any)
print(tonyConverted as Any)
print(tonyNil as Any)

print("prining fields:")
let metadata = Metadata(ofType: User.self)
for fieldType in metadata.fieldTypes {
    print(fieldType)
}

if metadata.kind == .struct {
    print("surprise")
}
