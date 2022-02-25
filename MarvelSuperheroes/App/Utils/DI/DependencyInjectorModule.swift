//
//  DependencyInjectorModule.swift
//  MarvelSuperheroes
//
//  Created by Arturo Murillo on 2/22/22.
//

import Foundation

final class DependencyInjectorModule {
    static func start() {
        DependencyContainer.registerBuilder(for: Server.self) {
            return Networker()
        }
        DependencyContainer.registerBuilder(for: EndpointRequester.self) {
            return EndpointNetWorker()
        }
    }
}
