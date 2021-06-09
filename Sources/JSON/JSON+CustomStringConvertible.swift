extension JSON: CustomStringConvertible {
    
    @inlinable
    public var description: String {
        return description(of: self)
    }
    
    @inlinable
    func description(of value: JSON, depth: Int = 0) -> String {
        switch value {
        case .null:
            return "null"
        case let .bool(bool):
            return bool.description
        case let .int(int):
            return int.description
        case let .double(double):
            return double.description
        case let .string(string):
            return escape(string)
        case let .array(array):
            return description(of: array, depth: depth + 1)
        case let .dictionary(dictionary):
            return description(of: dictionary, depth: depth + 1)
        }
    }
    
    @inlinable
    func description(of dictionary: [String: JSON], depth: Int = 0) -> String {
        if dictionary.isEmpty { return "{}" }
        return "{\n" + dictionary.sorted { $0.0 < $1.0 }.map {
            indentation(withLevel: depth) + escape($0) + ": " + description(of: $1, depth: depth)
        }.joined(separator: ",\n") + "\n" + indentation(withLevel: depth-1) + "}"
    }
    
    @inlinable
    func description(of array: [JSON], depth: Int = 0) -> String {
        if array.isEmpty { return "[]" }
        return "[\n" + array.map {
            indentation(withLevel: depth) + description(of: $0, depth: depth)
        }.joined(separator: ",\n") + "\n" + indentation(withLevel: depth-1) + "]"
    }

    @inlinable
    func indentation(withLevel level: Int) -> String {
        return String(repeating: "  ", count: level)
    }
    
    @inlinable
    func escape(_ string: String) -> String {
        let pairs: [Unicode.Scalar: String] = [
            "\"": "\\\"",
            "\\": "\\\\",
            "/": "\\/",
            "\u{8}": "\\b",
            "\u{c}": "\\f",
            "\n": "\\n",
            "\r": "\\r",
            "\t": "\\t"
        ]
        return "\"" + string.unicodeScalars.map { scalar in
            if let escaped = pairs[scalar] { return escaped }
            if "\u{0}"..."\u{f}" ~= scalar {
                return "\\u000" + String(scalar.value, radix: 16)
            }
            if "\u{10}"..."\u{1f}" ~= scalar {
                return "\\u00" + String(scalar.value, radix: 16)
            }
            return String(scalar)
        }.joined() + "\""
    }
}

extension JSON {

    @inlinable
    public var text: String {
        switch self {
        case .null:
            return "null"
        case .bool(let bool):
            return bool.description
        case .int(let int):
            return int.description
        case .double(let double):
            return double.description
        case .string(let string):
            return escape(string)
        case .array(let array):
            return "[" + array.map(\.text).joined(separator: ",") + "]"
        case .dictionary(let dictionary):
            return "{" + dictionary.map {
                escape($0) + ":" + $1.text
            }.joined(separator: ",") + "}"
        }
    }
}
