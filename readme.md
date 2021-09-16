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
