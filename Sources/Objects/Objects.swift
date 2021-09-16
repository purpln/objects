public protocol Object { init() }

public class Provider {
    private static var instance: Provider?
    
    public var registry: [String: Object.Type] = [:]
    
    public static subscript<T: Object>(key: T.Type) -> Provider { shared.type(key) }
    public static subscript(key: String) -> Object? { shared.registry[key]?.init() }
    public subscript(key: String) -> Object? { registry[key]?.init() }
    
    @discardableResult public
    func type<T: Object>(_ type: T.Type) -> Self {
        registry[String(describing: type)] = type
        return self
    }
    
    private init() { }
}

extension Provider {
    public class var shared: Provider {
        guard let instance = self.instance else {
            let instance = Provider()
            self.instance = instance
            return instance
        }
        return instance
    }
    
    public class func destroy() { instance = nil }
}
