//
//  CharacterListFlowPresenter.swift
//  MarvelSuperheroes
//
//  Created by Arturo Murillo on 2/20/22.
//

import Foundation

protocol CharacterListFlowPresentable {
    
}

final class CharacterListFlowPresenter: CharacterListFlowPresentable {
    private let interactor: CharacterListFlowInteractable
    private let router: CharacterListFlowRoutable
    
    init(interactor: CharacterListFlowInteractable, router: CharacterListFlowRoutable) {
        self.interactor = interactor
        self.router = router
    }
    
    func start() {
        router.route(to: .start(presenter: self))
    }
}
