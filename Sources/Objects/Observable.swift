//
//  File.swift
//  
//
//  Created by Sergey Romanenko on 19.09.2021.
//

import Foundation

@propertyWrapper
public class Observable<Value> {
    public var closure: ((ObservableData<Value>)->())
    var value: Value
    
    public func set(_ value: Value){
        let old = self.value
        self.value = value
        closure(ObservableData(old: old, new: value))
    }
    
    public func silent(_ value: Value) {
        self.value = value
    }
    
    public func add(_ closure: @escaping (ObservableData<Value>)->()) {
        self.closure = closure
    }
    
    public var projectedValue: Observable<Value> { self }
    public var wrappedValue: Value {
        set(wrappedValue) { set(wrappedValue) }
        get{ value }
    }
    public init(wrappedValue: Value) {
        self.value = wrappedValue
        closure = { _ in }
    }
}

public struct ObservableData<Value> {
    public var old: Value
    public var new: Value
}
