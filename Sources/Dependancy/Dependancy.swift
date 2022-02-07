import Foundation

public protocol AnyDependent { }
private extension AnyDependent {
    init(_ closure: () -> Self) { self = closure() }
}
public protocol Dependent: AnyObject, AnyDependent {
    associatedtype Dependency: DependencyProtocol
    var dependency: Dependency { get set }
}
public extension Dependent {
    init(_ dependency: Dependency, _ init: @autoclosure () -> Self){
        Dependency.dependency = dependency
        self.init(`init`)
        Dependency.dependency = nil
    }
}
public protocol DependencyProtocol { init() }
public extension DependencyProtocol {
    static func setup(_ init: @autoclosure ()->(Self) = .init()) -> Self{
        if let dependency = dependency {
            self.dependency = nil
            return dependency
        } else {
            return `init`()
        }
    }
}
private extension DependencyProtocol {
    private static var dependencyKey: String { "DependencyKey" }
    static var dependency: Self? {
        set(value){ Thread.current.threadDictionary[dependencyKey] = value }
        get{ Thread.current.threadDictionary[dependencyKey] as? Self }
    }
}
