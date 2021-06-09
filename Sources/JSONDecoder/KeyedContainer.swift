import JSON

@usableFromInline
struct KeyedContainer<Key: CodingKey> {

    @usableFromInline
    let content: [String: JSON]

    @usableFromInline
    let codingPath: [CodingKey]

    @usableFromInline
    let userInfo: [CodingUserInfoKey: Any]

    @inlinable
    init(content: [String: JSON], codingPath: [CodingKey], userInfo: [CodingUserInfoKey: Any]) {
        self.content = content
        self.codingPath = codingPath
        self.userInfo = userInfo
    }
}

extension KeyedContainer: KeyedDecodingContainerProtocol {

    @inlinable
    var allKeys: [Key] {
        return content.keys.compactMap(Key.init)
    }

    @inlinable
    func contains(_ key: Key) -> Bool {
        return content[key.stringValue] != nil
    }

    @inlinable
    func decodeNil(forKey key: Key) throws -> Bool {
        switch content[key.stringValue] {
        case .none:
            throw DecodingError.keyNotFound(key, codingPath)
        case .null:
            return true
        default:
            return false
        }
    }

    @inlinable
    func decode(_ type: Bool.Type, forKey key: Key) throws -> Bool {
        switch content[key.stringValue] {
        case .none:
            throw DecodingError.keyNotFound(key, codingPath)
        case let .bool(bool):
            return bool
        case .null:
            throw DecodingError.valueNotFound(type, codingPath + [key])
        default:
            throw DecodingError.typeMismatch(type, codingPath + [key])
        }
    }

    @inlinable
    func decode(_ type: Int.Type, forKey key: Key) throws -> Int {
        switch content[key.stringValue] {
        case .none:
            throw DecodingError.keyNotFound(key, codingPath)
        case let .int(int):
            return int
        case .null:
            throw DecodingError.valueNotFound(type, codingPath + [key])
        default:
            throw DecodingError.typeMismatch(type, codingPath + [key])
        }
    }

    @inlinable
    func decode(_ type: Double.Type, forKey key: Key) throws -> Double {
        switch content[key.stringValue] {
        case .none:
            throw DecodingError.keyNotFound(key, codingPath)
        case let .double(double):
            return double
        case .null:
            throw DecodingError.valueNotFound(type, codingPath + [key])
        default:
            throw DecodingError.typeMismatch(type, codingPath + [key])
        }
    }

    @inlinable
    func decode(_ type: String.Type, forKey key: Key) throws -> String {
        switch content[key.stringValue] {
        case .none:
            throw DecodingError.keyNotFound(key, codingPath)
        case let .string(string):
            return string
        case .null:
            throw DecodingError.valueNotFound(type, codingPath + [key])
        default:
            throw DecodingError.typeMismatch(type, codingPath + [key])
        }
    }

    @inlinable
    func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T: Decodable {
        switch content[key.stringValue] {
        case .none:
            throw DecodingError.keyNotFound(key, codingPath)
        case let .some(json):
            if let t = json as? T { return t }
            let container = Container(
                content: json,
                codingPath: codingPath + [key],
                userInfo: userInfo
            )
            return try T(from: container)
        }
    }

    @inlinable
    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey: CodingKey {
        switch content[key.stringValue] {
        case .none:
            throw DecodingError.keyNotFound(key, codingPath)
        case let .dictionary(dictionary):
            let container = KeyedContainer<NestedKey>(
                content: dictionary,
                codingPath: codingPath + [key],
                userInfo: userInfo
            )
            return KeyedDecodingContainer(container)
        case .null:
            throw DecodingError.valueNotFound([String: JSON].self, codingPath + [key])
        default:
            throw DecodingError.typeMismatch([String: JSON].self, codingPath + [key])
        }
    }

    @inlinable
    func nestedUnkeyedContainer(forKey key: Key) throws -> UnkeyedDecodingContainer {
        switch content[key.stringValue] {
        case .none:
            throw DecodingError.keyNotFound(key, codingPath)
        case let .array(array):
            return UnkeyedContainer(
                content: array,
                codingPath: codingPath + [key],
                userInfo: userInfo
            )
        case .null:
            throw DecodingError.valueNotFound([JSON].self, codingPath + [key])
        default:
            throw DecodingError.typeMismatch([JSON].self, codingPath + [key])
        }
    }

    @inlinable
    func superDecoder() throws -> Decoder {
        guard let key = Key(stringValue: "super") else {
            fatalError()
        }
        return try superDecoder(forKey: key)
    }

    @inlinable
    func superDecoder(forKey key: Key) throws -> Decoder {
        switch content[key.stringValue] {
        case .none:
            throw DecodingError.keyNotFound(key, codingPath)
        case let .some(json):
            return Container(
                content: json,
                codingPath: codingPath + [key],
                userInfo: userInfo
            )
        }
    }
}

