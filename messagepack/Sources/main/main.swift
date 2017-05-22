import MessagePack

do {
    let hey = MessagePack("hey there!")
    let bytes = MessagePack.encode(hey)
    if let original = String(try MessagePack.decode(bytes: bytes)) {
        print("original value: \(original)")
    }


    var encoder = Encoder()
    encoder.encode(.string("one"))
    encoder.encode(.int(2))
    encoder.encode(.double(3.0))
    let encoded = encoder.bytes
    // be careful, we use raw pointer here
    var decoder = Decoder(bytes: encoded, count: encoded.count)
    // throws on invalid data
    let value = try decoder.decode()
    print("decoded object: \(value)")
    // reuse decoder
    decoder.rewind()
    // you can avoid extra MessagePack object 
    // if you sure about the structure
    // throws on wrong type
    let string = try decoder.decode(String.self)
    let int = try decoder.decode(UInt8.self)
    let double = try decoder.decode(Double.self)
    print("decoded manually: \(string), \(int), \(double)")
} catch {
    print(error)
}
