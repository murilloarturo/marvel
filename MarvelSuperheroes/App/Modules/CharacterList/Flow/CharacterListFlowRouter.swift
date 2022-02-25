//
//  CharacterListFlowRouter.swift
//  MarvelSuperheroes
//
//  Created by Arturo Murillo on 2/20/22.
//

import UIKit

enum CharacterListRoute {
    case start(presenter: CharacterListFlowPresentable)
    case showDetail(model: Character)
    case showError(Error)
}

protocol CharacterListFlowRoutable {
    func route(to route: CharacterListRoute)
}

final class CharacterListFlowRouter: CharacterListFlowRoutable {
    private weak var window: UIWindow?
    private weak var baseViewController: UIViewController?
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func route(to route: CharacterListRoute) {
        switch route {
        case .start(let presenter):
            showListViewController(presenter: presenter)
        case .showDetail(let model):
            CharacterDetailFlowModule(model: model, navigation: baseViewController as? UINavigationController).start()
        case .showError(let error):
            baseViewController?.presentAlert(title: "Error", message: error.localizedDescription, dismissAction: "ok", dismissCompletion: nil, okAction: nil, okCompletion: nil)
        }
    }
    
    private func showListViewController(presenter: CharacterListFlowPresentable) {
        guard let window = window else { return }
        let viewController = CharacterListViewController(presenter: presenter)
        let navigation = UINavigationController(rootViewController: viewController)
        self.baseViewController = navigation
        viewController.view.frame = window.bounds
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
            window.rootViewController = navigation
            window.makeKeyAndVisible()
        }, completion: nil)
    }
}
