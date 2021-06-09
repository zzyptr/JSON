extension JSON: ExpressibleByBooleanLiteral {

    @inlinable
    public init(booleanLiteral bool: Bool) {
        self = .bool(bool)
    }
}

extension JSON: ExpressibleByIntegerLiteral {

    @inlinable
    public init(integerLiteral int: Int) {
        self = .int(int)
    }
}

extension JSON: ExpressibleByFloatLiteral {

    @inlinable
    public init(floatLiteral double: Double) {
        self = .double(double)
    }
}

extension JSON: ExpressibleByStringLiteral {

    @inlinable
    public init(stringLiteral string: String) {
        self = .string(string)
    }
}

extension JSON: ExpressibleByArrayLiteral {

    @inlinable
    public init(arrayLiteral elements: JSONConvertible...) {
        self = .array(elements.map(\.json))
    }
}

extension JSON: ExpressibleByDictionaryLiteral {

    @inlinable
    public init(dictionaryLiteral elements: (String, JSONConvertible)...) {
        let dictionary = elements.reduce(into: [:]) { result, element in
            result[element.0] = element.1.json
        }
        self = .dictionary(dictionary)
    }
}

public protocol JSONConvertible {

    var json: JSON { get }
}

extension JSON: JSONConvertible {

    @inlinable
    public var json: JSON { self }
}

extension Bool: JSONConvertible {

    @inlinable
    public var json: JSON { .bool(self) }
}

extension Int: JSONConvertible {

    @inlinable
    public var json: JSON { .int(self) }
}

extension Double: JSONConvertible {

    @inlinable
    public var json: JSON { .double(self) }
}

extension String: JSONConvertible {

    @inlinable
    public var json: JSON { .string(self) }
}

extension Array: JSONConvertible where Element == JSON {

    @inlinable
    public var json: JSON { .array(self) }
}

extension Dictionary: JSONConvertible where Key == String, Value == JSON {

    @inlinable
    public var json: JSON { .dictionary(self) }
}
