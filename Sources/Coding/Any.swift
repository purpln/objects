protocol ConvertValueProtocol {
    static func convertToUse(value: Any) -> Any
    static func convertToJson(value: Any) -> Any
}
extension ConvertValueProtocol{
    static func convertToUse(value: Any) -> Any { return value }
    static func convertToJson(value: Any) -> Any { return value }
}

protocol AnyExtensions {}
struct Extensions: AnyExtensions {}

extension AnyExtensions {
    public static var size: Int { MemoryLayout<Self>.size }
    public static var type: Any.Type { Swift.type(of: Self.self) }
    public static func setValueToAdress(_ adr: Int, _ value: Any?) {
        if let value = value as? Self {
            UnsafeMutablePointer<Self>(bitPattern: adr)?.pointee = value
            return
        }
        if let value = value, let type = Self.self as? ConvertValueProtocol.Type {
            setValueToAdress(adr, type.convertToUse(value: value))
            return
        }
    }
}

func extensions(of type: Any.Type) -> AnyExtensions.Type {
    var extensions: AnyExtensions.Type?
    withUnsafePointer(to: &extensions) { pointer in
        UnsafeMutableRawPointer(mutating: pointer).assumingMemoryBound(to: Any.Type.self).pointee = type
    }
    return extensions!
}

struct MemoryAddress<T>: CustomStringConvertible {
    let value: Int
    
    var description: String { .init(value+8, radix: 16) }
    
    init(of structPointer: UnsafePointer<T>) {
        value = Int(bitPattern: structPointer)
    }
}

extension Array: ConvertValueProtocol where Element: ConvertValueProtocol{
    static func convertToUse(value: Any) -> Any {
        if let array = value as? [Any] {
            return array.map{ Element.convertToUse(value: $0) }
        }
        return value
    }
}

extension Dictionary: ConvertValueProtocol where Value: ConvertValueProtocol, Key == String{
    static func convertToUse(value: Any) -> Any {
        if let array = value as? [String: Any] {
            return array.mapValues { Value.convertToUse(value: $0) }
        }
        return value
    }
}

extension Optional: ConvertValueProtocol where Wrapped: ConvertValueProtocol {
    static func convertToUse(value: Any) -> Any { Wrapped.convertToUse(value: value) }
}

