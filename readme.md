```swift
class Values: Coding {
    var string: String = "str"
    private var value: Double = 0.0
    var array: [String] = []
}

var values = Values()

print(values.values)
values.configure(["string":"string", "value":1.0, "array":["0"]])
print(values.values)
```

```swift
extension Object: Dependent {
    struct Dependency: DependencyProtocol {
        var int: Int = 0
        
        init() { }
        init(int: Int) { self.int = int }
    }
}

class Object {
    var dependency: Dependency = Dependency.setup()
    
    init(int: Int) {
        print(dependency.int, int)
    }
}

Object(.init(int: 100), .init(int: -100))
```

```swift
typealias objc = Provider

struct Test: Object {
    var value: String = "c value"
    
    init() { }
}

_ = objc[Test.self]


guard let test = objc["Test"] as? Test else { return }

print(test.value)
```
