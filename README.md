# Dependency Injection 

Dependency Injection is a software design pattern in which an object receives other instances that it depends on. It’s a commonly used technique that allows reusing code, insert mocked data, and simplify testing. An example could be initializing a view with the network provider as a dependency.

## Why would you need dependency injection?

* Mocking/Stubing data for tests should be easy
* Readability should be maintained by staying close to Swift’s standard APIs
* Compile-time safety is prefered to prevent hidden crashes. If the app builds, we know all dependencies are configured correctly
* Big initialisers as a result of injecting dependencies should be avoided
* The AppDelegate should not be the place to define all shared instances
* No 3rd party dependency to prevent potential learning curves
* Force unwrapping shouldn’t be needed
* Defining standard dependency should be possible without exposing private/internal types within packages
* The solution should be defined in a package that can be shared across libraries for reusability

## Implementation key features

* Vanilla **Static Subscripts** + **Extensions** + **Property Wrappers** implementation
* **Swift 5.1** and newer
* **Property Wrapper** allows injecting dependencies and reduces code clutter
* There’s no need for big initializers
* Possibility to override dependencies for tests
* Without **3rd party library**