public protocol Coding: Decoding, Encoding { }

public protocol Decoding {
    mutating func configure(_ values: Any)
}

public extension Decoding {
    mutating func configure(_ values: Any) {
        guard let values = values as? [String: Any] else { return }
        var types: [String: (AnyExtensions.Type, Int)] = [:]
        let address = address()
        let properties = properties()
        for (label, value) in mirror.children {
            guard let label = label else { continue }
            if let mod = properties[label] {
                let type = extensions(of: type(of: value))
                types[label] = (type, mod)
                type.setValueToAdress(address + mod, values[label])
            }
        }
    }
    //private var key: UnsafeRawPointer { UnsafeRawPointer(bitPattern: "\(Self.self)".hashValue)! }
    private var mirror: Mirror { Mirror(reflecting: self) }
    private var structure: Bool { mirror.displayStyle == .struct }
}

public extension Decoding {
    mutating func address() -> Int { structure ? addressStruct() : addressClass() }
    mutating func properties() -> [String: Int] { structure ? propertiesStruct() : propertiesClass() }
}

extension Decoding {
    private mutating func addressStruct() -> Int { MemoryAddress(of: &self).value }
    private mutating func propertiesStruct() -> [String: Int] {
        var list: [String: Int] = [:]
        var address = 0
        for (label, value) in mirror.children {
            guard let label = label else { continue }
            list[label] = address
            address += extensions(of: type(of: value)).size
        }
        return list
    }
}

extension Decoding {
    private func addressClass() -> Int { unsafeBitCast(self, to: Int.self) }
    private func propertiesClass() -> [String: Int] {
        var list: [String: Int] = [:]
        var address = 16
        for (label, value) in mirror.children {
            guard let label = label else { continue }
            list[label] = address
            address += extensions(of: type(of: value)).size
        }
        return list
    }
}

public protocol Encoding {
    var dictionary: [String: Any] { get }
}

public extension Encoding {
    var dictionary: [String: Any] {
        var dictionary: [String: Any] = [:]
        for (key, value) in values {
            dictionary[key] = convert(value)
        }
        return dictionary
    }
    
    var values: [String: Any] {
        let mirror = Mirror(reflecting: self)
        var dictionary: [String: Any] = [:]
        for i in mirror.children {
            guard let label = i.label else { continue }
            dictionary[label] = i.value
        }
        return dictionary
    }
    
    private func convert(_ any: Any) -> Any {
        if let array = any as? [Any] {
            var dictionary: [Any] = []
            for i in array {
                dictionary.append(convert(i))
            }
            return dictionary
        } else if let value = check(any) {
            return value
        } else { return any }
    }
    
    private func check(_ value : Any) -> Any? {
        let value = unwrap(any: value)
        print(value, type(of: value), value is Encoding)
        if let model = value as? Encoding {
            return model.dictionary
        } else { return value }
    }
    
    func unwrap(any: Any) -> Any? {
        let mirror = Mirror(reflecting: any)
        if mirror.displayStyle != .optional { return any }
        
        guard let (_, some) = mirror.children.first else { return nil }
        return some
    }
}

