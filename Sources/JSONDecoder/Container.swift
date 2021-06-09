import JSON

@usableFromInline
struct Container {

    @usableFromInline
    let content: JSON

    @usableFromInline
    let codingPath: [CodingKey]

    @usableFromInline
    let userInfo: [CodingUserInfoKey: Any]

    @inlinable
    init(content: JSON, codingPath: [CodingKey], userInfo: [CodingUserInfoKey: Any]) {
        self.content = content
        self.codingPath = codingPath
        self.userInfo = userInfo
    }
}

extension Container: SingleValueDecodingContainer {

    @inlinable
    func decodeNil() -> Bool {
        switch content {
        case .null:
            return true
        default:
            return false
        }
    }

    @inlinable
    func decode(_ type: Bool.Type) throws -> Bool {
        switch content {
        case let .bool(bool):
            return bool
        case .null:
            throw DecodingError.valueNotFound(type, codingPath)
        default:
            throw DecodingError.typeMismatch(type, codingPath)
        }
    }

    @inlinable
    func decode(_ type: Int.Type) throws -> Int {
        switch content {
        case let .int(int):
            return int
        case .null:
            throw DecodingError.valueNotFound(type, codingPath)
        default:
            throw DecodingError.typeMismatch(type, codingPath)
        }
    }

    @inlinable
    func decode(_ type: Double.Type) throws -> Double {
        switch content {
        case let .double(double):
            return double
        case .null:
            throw DecodingError.valueNotFound(type, codingPath)
        default:
            throw DecodingError.typeMismatch(type, codingPath)
        }
    }

    @inlinable
    func decode(_ type: String.Type) throws -> String {
        switch content {
        case let .string(string):
            return string
        case .null:
            throw DecodingError.valueNotFound(type, codingPath)
        default:
            throw DecodingError.typeMismatch(type, codingPath)
        }
    }

    @inlinable
    func decode<T>(_ type: T.Type) throws -> T where T: Decodable {
        if let t = content as? T { return t }
        return try T(from: self)
    }
}

extension Container: Decoder {

    @inlinable
    func singleValueContainer() throws -> SingleValueDecodingContainer {
        return self
    }

    @inlinable
    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        switch content {
        case let .array(array):
            return UnkeyedContainer(
                content: array,
                codingPath: codingPath,
                userInfo: userInfo
            )
        case .null:
            throw DecodingError.valueNotFound([JSON].self, codingPath)
        default:
            throw DecodingError.typeMismatch([JSON].self, codingPath)
        }
    }

    @inlinable
    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key: CodingKey {
        switch content {
        case let .dictionary(dictionary):
            let container = KeyedContainer<Key>(
                content: dictionary,
                codingPath: codingPath,
                userInfo: userInfo
            )
            return KeyedDecodingContainer(container)
        case .null:
            throw DecodingError.valueNotFound([String: JSON].self, codingPath)
        default:
            throw DecodingError.typeMismatch([String: JSON].self, codingPath)
        }
    }
}
