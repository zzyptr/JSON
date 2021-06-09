extension DecodingError {

    @inlinable
    static func typeMismatch(_ type: Any.Type, _ codingPath: [CodingKey]) -> DecodingError {
        let context = Context(
            codingPath: codingPath,
            debugDescription: "",
            underlyingError: nil
        )
        return typeMismatch(type, context)
    }

    @inlinable
    static func valueNotFound(_ type: Any.Type, _ codingPath: [CodingKey]) -> DecodingError {
        let context = Context(
            codingPath: codingPath,
            debugDescription: "",
            underlyingError: nil
        )
        return valueNotFound(type, context)
    }

    @inlinable
    static func keyNotFound(_ key: CodingKey, _ codingPath: [CodingKey]) -> DecodingError {
        let context = Context(
            codingPath: codingPath,
            debugDescription: "",
            underlyingError: nil
        )
        return keyNotFound(key, context)
    }
}

