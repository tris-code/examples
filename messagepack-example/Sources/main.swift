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
    let value = try decoder.decode() as MessagePack
    print("decoded object: \(value)")
    // reuse decoder
    decoder.rewind()
    // you can avoid extra MessagePack object if you sure about structure
    // throws on wrong type
    let string = try decoder.decode() as String
    let int = try decoder.decode() as UInt8
    let double = try decoder.decode() as Double
    print("decoded manually: \(string), \(int), \(double)")
} catch {
    print(error)
}
