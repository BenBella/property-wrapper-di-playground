import UIKit

protocol NetworkProviding {
    func requestData()
}

struct NetworkProvider: NetworkProviding {
    func requestData() {
        print("Data requested using the `NetworkProvider`")
    }
}

struct MockedNetworkProvider: NetworkProviding {
    func requestData() {
        print("Data requested using the `MockedNetworkProvider`")
    }
}

protocol LoggerProviding {
    func log()
}

struct LoggerProvider: LoggerProviding {
    func log() {
        print("Log using the `LoggerProvider`")
    }
}

struct MockedLoggerProvider: LoggerProviding {
    func log() {
        print("Log using the `MockedLoggerProvider`")
    }
}


public protocol InjectionKey {

    /// The associated type representing the type of the dependency injection key's value.
    associatedtype Value

    /// The default value for the dependency injection key.
    static var currentValue: Self.Value { get set }
}

private struct NetworkProviderKey: InjectionKey {
    static var currentValue: NetworkProviding = NetworkProvider()
}

private struct LoggerProviderKey: InjectionKey {
    static var currentValue: LoggerProviding = LoggerProvider()
}

/// Provides access to injected dependencies.
struct InjectedValues {
    
    /// This is only used as an accessor to the computed properties within extensions of `InjectedValues`.
    private static var current = InjectedValues()
    
    /// A static subscript for updating the `currentValue` of `InjectionKey` instances.
    static subscript<K>(key: K.Type) -> K.Value where K : InjectionKey {
        get { key.currentValue }
        set { key.currentValue = newValue }
    }
    
    /// A static subscript accessor for updating and references dependencies directly.
    static subscript<T>(_ keyPath: WritableKeyPath<InjectedValues, T>) -> T {
        get { current[keyPath: keyPath] }
        set { current[keyPath: keyPath] = newValue }
    }
}

/*
 
*/
extension InjectedValues {
    var networkProvider: NetworkProviding {
        get { Self[NetworkProviderKey.self] }
        set { Self[NetworkProviderKey.self] = newValue }
    }
}

extension InjectedValues {
    var loggerProvider: LoggerProviding {
        get { Self[LoggerProviderKey.self] }
        set { Self[LoggerProviderKey.self] = newValue }
    }
}

@propertyWrapper
struct Injected<T> {
    private let keyPath: WritableKeyPath<InjectedValues, T>
    var wrappedValue: T {
        get { InjectedValues[keyPath] }
        set { InjectedValues[keyPath] = newValue }
    }
    
    init(_ keyPath: WritableKeyPath<InjectedValues, T>) {
        self.keyPath = keyPath
    }
}

// Usage example

struct DataController {
    @Injected(\.networkProvider) var networkProvider: NetworkProviding
    @Injected(\.loggerProvider) var loggerProvider: LoggerProviding
    
    func performDataRequest() {
        networkProvider.requestData()
        loggerProvider.log()
    }
}

var dataController = DataController()
print(dataController.networkProvider) // prints: NetworkProvider()

InjectedValues[\.networkProvider] = MockedNetworkProvider()
print(dataController.networkProvider) // prints: MockedNetworkProvider()

dataController.networkProvider = NetworkProvider()
print(dataController.networkProvider) // prints 'NetworkProvider' as we overwritten the property wrapper wrapped value

dataController.performDataRequest()
