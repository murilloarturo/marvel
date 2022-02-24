//
//  DependencyInjector.swift
//  MarvelSuperheroes
//
//  Created by Arturo Murillo on 2/22/22.
//

import Foundation

@propertyWrapper
struct Dependency<T> {
    var wrappedValue: T?

    init() {
        self.wrappedValue = DependencyContainer.resolve()
    }
}

final class DependencyContainer {
    private var dependencyBuilders = [String: (() -> AnyObject)]()
    private var dependencies = [String: (AnyObject)]()
    private static var shared = DependencyContainer()

    static func register<T>(_ dependency: T) {
        shared.register(dependency)
    }
    
    static func registerBuilder<T>(for type: T.Type, dependencyBuilder: @escaping () -> AnyObject) {
        shared.registerBuilder(for: type, dependencyBuilder: dependencyBuilder)
    }

    static func resolve<T>() -> T? {
        shared.resolve()
    }

    private func register<T>(_ dependency: T) {
        let key = String(describing: T.self)
        dependencies[key] = dependency as AnyObject
    }
    
    private func registerBuilder<T>(for type: T.Type, dependencyBuilder: @escaping () -> AnyObject) {
        let key = String(describing: type)
        dependencyBuilders[key] = dependencyBuilder
    }

    private func resolve<T>() -> T? {
        let key = String(describing: T.self)
        if let builder = dependencyBuilders[key] {
            return builder() as? T
        } else {
            return dependencies[key] as? T
        }
    }
}
