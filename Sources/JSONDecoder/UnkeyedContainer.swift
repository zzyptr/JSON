import JSON

@usableFromInline
struct UnkeyedContainer {

    @usableFromInline
    let content: [JSON]

    @usableFromInline
    let codingPath: [CodingKey]

    @usableFromInline
    let userInfo: [CodingUserInfoKey: Any]

    @usableFromInline
    var currentIndex = 0

    @inlinable
    init(content: [JSON], codingPath: [CodingKey], userInfo: [CodingUserInfoKey: Any]) {
        self.content = content
        self.codingPath = codingPath
        self.userInfo = userInfo
    }
}

extension UnkeyedContainer: UnkeyedDecodingContainer {

    @inlinable
    var count: Int? {
        return content.count
    }

    @inlinable
    var isAtEnd: Bool {
        return currentIndex == content.count
    }

    @inlinable
    var currentKey: Key {
        return Key(intValue: currentIndex)
    }

    @inlinable
    mutating func decodeNil() throws -> Bool {
        switch content[currentIndex] {
        case .null:
            currentIndex += 1
            return true
        default:
            return false
        }
    }

    @inlinable
    mutating func decode(_ type: Bool.Type) throws -> Bool {
        switch content[currentIndex] {
        case let .bool(bool):
            currentIndex += 1
            return bool
        case .null:
            throw DecodingError.valueNotFound(type, codingPath + [currentKey])
        default:
            throw DecodingError.typeMismatch(type, codingPath + [currentKey])
        }
    }

    @inlinable
    mutating func decode(_ type: Int.Type) throws -> Int {
        switch content[currentIndex] {
        case let .int(int):
            currentIndex += 1
            return int
        case .null:
            throw DecodingError.valueNotFound(type, codingPath + [currentKey])
        default:
            throw DecodingError.typeMismatch(type, codingPath + [currentKey])
        }
    }

    @inlinable
    mutating func decode(_ type: Double.Type) throws -> Double {
        switch content[currentIndex] {
        case let .double(double):
            currentIndex += 1
            return double
        case .null:
            throw DecodingError.valueNotFound(type, codingPath + [currentKey])
        default:
            throw DecodingError.typeMismatch(type, codingPath + [currentKey])
        }
    }

    @inlinable
    mutating func decode(_ type: String.Type) throws -> String {
        switch content[currentIndex] {
        case let .string(string):
            currentIndex += 1
            return string
        case .null:
            throw DecodingError.valueNotFound(type, codingPath + [currentKey])
        default:
            throw DecodingError.typeMismatch(type, codingPath + [currentKey])
        }
    }

    @inlinable
    mutating func decode<T>(_ type: T.Type) throws -> T where T: Decodable {
        let json = content[currentIndex]
        if let t = json as? T { return t }
        let container = SingleValueContainer(
            content: json,
            codingPath: codingPath + [currentKey],
            userInfo: userInfo
        )
        return try T(from: container)
    }

    @inlinable
    mutating func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey: CodingKey {
        switch content[currentIndex] {
        case let .dictionary(dictionary):
            currentIndex += 1
            let container = KeyedContainer<NestedKey>(
                content: dictionary,
                codingPath: codingPath + [currentKey],
                userInfo: userInfo
            )
            return KeyedDecodingContainer(container)
        case .null:
            throw DecodingError.valueNotFound([String: JSON].self, codingPath + [currentKey])
        default:
            throw DecodingError.typeMismatch([String: JSON].self, codingPath + [currentKey])
        }
    }

    @inlinable
    mutating func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
        switch content[currentIndex] {
        case let .array(array):
            currentIndex += 1
            return UnkeyedContainer(
                content: array,
                codingPath: codingPath + [currentKey],
                userInfo: userInfo
            )
        case .null:
            throw DecodingError.valueNotFound([JSON].self, codingPath + [currentKey])
        default:
            throw DecodingError.typeMismatch([JSON].self, codingPath + [currentKey])
        }
    }

    @inlinable
    mutating func superDecoder() throws -> Decoder {
        return SingleValueContainer(
            content: content[currentIndex],
            codingPath: codingPath + [currentKey],
            userInfo: userInfo
        )
    }

    @usableFromInline
    struct Key: CodingKey {

        @usableFromInline
        let index: Int

        @inlinable
        var intValue: Int? {
            return index
        }

        @inlinable
        var stringValue: String {
            return String(index)
        }

        @inlinable
        init(intValue: Int) {
            self.index = intValue
        }

        @inlinable
        init?(stringValue: String) {
            return nil
        }
    }
}
