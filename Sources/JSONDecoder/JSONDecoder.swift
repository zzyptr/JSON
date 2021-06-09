import JSON

public struct JSONDecoder {

    @inlinable
    public static func decode<T: Decodable>(from json: JSON, userInfo: [CodingUserInfoKey: Any]) throws -> T {
        let container = Container(
            content: json,
            codingPath: [],
            userInfo: userInfo
        )
        return try T(from: container)
    }

    @inlinable
    public static func decode<T: Decodable>(from json: JSON) throws -> T {
        let container = Container(
            content: json,
            codingPath: [],
            userInfo: [:]
        )
        return try T(from: container)
    }

    @inlinable
    public static func decode<T: Decodable>(_ type: T.Type, from json: JSON, userInfo: [CodingUserInfoKey: Any]) throws -> T {
        let container = Container(
            content: json,
            codingPath: [],
            userInfo: userInfo
        )
        return try T(from: container)
    }

    @inlinable
    public static func decode<T: Decodable>(_ type: T.Type, from json: JSON) throws -> T {
        let container = Container(
            content: json,
            codingPath: [],
            userInfo: [:]
        )
        return try T(from: container)
    }
}

