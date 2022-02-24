//
//  DependencyInjectorModule.swift
//  MarvelSuperheroes
//
//  Created by Arturo Murillo on 2/22/22.
//

import Foundation

final class DependencyInjectorModule {
    static func start() {
        DependencyContainer.registerBuilder(for: CharacterServer.self) {
            return CharacterNetworker()
        }
    }
}
