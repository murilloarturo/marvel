//
//  CharacterDetailFlowModule.swift
//  MarvelSuperheroes
//
//  Created by Arturo Murillo on 2/24/22.
//

import Foundation
import UIKit

final class CharacterDetailFlowModule {
    private let presenter: CharacterDetailFlowPresenter
    
    init(model: Character, navigation: UINavigationController?) {
        let interactor = CharacterDetailFlowInteractor(character: model)
        let router = CharacterDetailFlowRouter(navigation: navigation)
        presenter = CharacterDetailFlowPresenter(interactor: interactor, router: router)
    }
    
    func start() {
        presenter.start()
    }
}
