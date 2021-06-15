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
    public init(arrayLiteral elements: JSON...) {
        self = .array(elements)
    }
}

extension JSON: ExpressibleByDictionaryLiteral {

    @inlinable
    public init(dictionaryLiteral elements: (String, JSON)...) {
        let dictionary = Dictionary(elements, uniquingKeysWith: { $1 })
        self = .dictionary(dictionary)
    }
}
