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

extension JSON: Codable {
    
    @inlinable
    public init(from decoder: Decoder) throws {
        self = .null
    }
    
    @inlinable
    public func encode(to encoder: Encoder) throws {}
}

extension JSON: CustomReflectable {
    
    @inlinable
    public var customMirror: Mirror {
        return Mirror(self, children: [])
    }
}
