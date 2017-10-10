import Stream
import MessagePack

do {
    let hey = MessagePack("hey there!")
    let bytes = try MessagePack.encode(hey)
    if let original = String(try MessagePack.decode(bytes: bytes)) {
        print("original value: \(original)")
    }

    var encoder = MessagePackWriter(OutputByteStream())
    try encoder.encode("one")
    try encoder.encode(2)
    try encoder.encode(3.0)
    let encoded = encoder.stream.bytes
    
    var decoder = MessagePackReader(InputByteStream(encoded))
    let string = try decoder.decode(String.self)
    let int = try decoder.decode(UInt8.self)
    let double = try decoder.decode(Double.self)
    print("decoded manually: \(string), \(int), \(double)")
} catch {
    print(error)
}
