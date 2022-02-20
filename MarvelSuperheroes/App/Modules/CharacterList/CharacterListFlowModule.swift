//
//  CharacterListFlowModule.swift
//  MarvelSuperheroes
//
//  Created by Arturo Murillo on 2/20/22.
//

import UIKit

final class CharacterListFlowModule {
    private let presenter: CharacterListFlowPresenter
    
    init(window: UIWindow) {
        let interactor = CharacterListFlowInteractor()
        let router = CharacterListFlowRouter(window: window)
        presenter = CharacterListFlowPresenter(interactor: interactor, router: router)
    }
    
    func start() {
        presenter.start()
    }
}
