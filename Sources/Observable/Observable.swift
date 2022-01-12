@propertyWrapper
public class Observable<Value> {
    public var closures: [(ObservableData<Value>) -> Void] = []
    var value: Value
    
    public func set(_ value: Value){
        let old = self.value
        self.value = value
        closures.forEach { $0(ObservableData(old: old, new: value)) }
    }
    
    public func silent(_ value: Value) {
        self.value = value
    }
    
    public func add(_ closure: @escaping (ObservableData<Value>)->()) {
        closures.append(closure)
    }
    
    public var projectedValue: Observable<Value> { self }
    public var wrappedValue: Value {
        set(wrappedValue) { set(wrappedValue) }
        get{ value }
    }
    public init(wrappedValue: Value) {
        self.value = wrappedValue
    }
}

public struct ObservableData<Value> {
    public var old: Value
    public var new: Value
}
