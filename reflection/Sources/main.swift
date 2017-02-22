import Reflection

struct User {
    let name: String
    let age: Int
}

let blueprint = Blueprint(ofType: User.self)

let userDictionary = ["name" : "Tony", "age" : "7"]
let tony = blueprint.construct(using: userDictionary) // ok, parse string by default
let tonyNil = blueprint.construct(using: userDictionary, exact: true) // fail

let userDictionaryExact: [String : Any] = ["name" : "Tony", "age" : 7]
let tonyExact = blueprint.construct(using: userDictionaryExact, exact: true) // ok

print(tony as Any)
print(tonyNil as Any)
print(tonyExact as Any)


let metadata = Metadata(ofType: User.self)
for fieldType in metadata.fieldTypes {
    print(fieldType)
}

if metadata.kind == .struct {
    print("surprise")
}
