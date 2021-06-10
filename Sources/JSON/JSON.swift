public enum JSON {
    case null
    case bool(Bool)
    case int(Int)
    case double(Double)
    case string(String)
    case array([JSON])
    case dictionary([String: JSON])
}

extension JSON: Equatable {
    
    @inlinable
    public static func == (lhs: JSON, rhs: JSON) -> Bool {
        switch (lhs, rhs) {
        case (.null, .null):
            return true
        case let (.bool(left), .bool(right)):
            return left == right
        case let (.int(left), .int(right)):
            return left == right
        case let (.double(left), .double(right)):
            return left == right
        case let (.string(left), .string(right)):
            return left == right
        case let (.array(left), .array(right)):
            return left == right
        case let (.dictionary(left), .dictionary(right)):
            return left == right
        default:
            return false
        }
    }
}

extension JSON: Decodable {
    
    @inlinable
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if container.decodeNil() {
            self = .null
        } else if let bool = try? container.decode(Bool.self) {
            self = .bool(bool)
        } else if let int = try? container.decode(Int.self) {
            self = .int(int)
        } else if let double = try? container.decode(Double.self) {
            self = .double(double)
        } else if let string = try? container.decode(String.self) {
            self = .string(string)
        } else if let array = try? container.decode([JSON].self) {
            self = .array(array)
        } else {
            let dictionary = try container.decode([String: JSON].self)
            self = .dictionary(dictionary)
        }
    }
}

extension JSON: CustomReflectable {
    
    @inlinable
    public var customMirror: Mirror {
        return Mirror(self, children: [])
    }
}
