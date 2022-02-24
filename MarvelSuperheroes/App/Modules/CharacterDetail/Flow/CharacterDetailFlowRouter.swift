//
//  CharacterDetailFlowRouter.swift
//  MarvelSuperheroes
//
//  Created by Arturo Murillo on 2/24/22.
//

import UIKit

enum CharacterDetailFlowRoute {
    case start(preseter: CharacterDetailFlowPresentable)
}

protocol CharacterDetailFlowRoutable {
    func route(to route: CharacterDetailFlowRoute)
}

final class CharacterDetailFlowRouter: CharacterDetailFlowRoutable {
    private weak var navigation: UINavigationController?
    
    init(navigation: UINavigationController?) {
        self.navigation = navigation
    }
    
    func route(to route: CharacterDetailFlowRoute) {
        switch route {
        case .start(let preseter):
            start(presenter: preseter)
        }
    }
    
    private func start(presenter: CharacterDetailFlowPresentable) {
        let vc = CharacterDetailViewController(presenter: presenter)
        navigation?.pushViewController(vc, animated: true)
    }
}
