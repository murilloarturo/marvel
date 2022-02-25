//
//  CharacterDetailFlowRouter.swift
//  MarvelSuperheroes
//
//  Created by Arturo Murillo on 2/24/22.
//

import UIKit

enum CharacterDetailFlowRoute {
    case start(preseter: CharacterDetailFlowPresentable)
    case showWebView(url: URL)
    case showError(Error)
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
        case .showWebView(let url):
            let webView = WebViewController(url: url)
            navigation?.pushViewController(webView, animated: true)
        case .showError(let error):
            navigation?.topViewController?.presentAlert(title: LocalizableString.error.localized,
                                                        message: error.localizedDescription,
                                                        dismissAction: LocalizableString.ok.localized)
        }
    }
    
    private func start(presenter: CharacterDetailFlowPresentable) {
        let vc = CharacterDetailViewController(presenter: presenter)
        navigation?.pushViewController(vc, animated: true)
    }
}