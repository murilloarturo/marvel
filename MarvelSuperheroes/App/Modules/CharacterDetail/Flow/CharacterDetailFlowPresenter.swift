//
//  CharacterDetailFlowPresenter.swift
//  MarvelSuperheroes
//
//  Created by Arturo Murillo on 2/24/22.
//

import Foundation
import RxCocoa

protocol CharacterDetailFlowPresentable {
    var characterImage: Driver<URL?> { get }
    var items: Driver<[Any]> { get }
    
    func handle(viewAction: CharacterDetailViewAction)
}

final class CharacterDetailFlowPresenter: CharacterDetailFlowPresentable {
    private let interactor: CharacterDetailFlowInteractable
    private let router: CharacterDetailFlowRoutable
    var characterImage: Driver<URL?> {
        return interactor.model.map{ $0.thumbnail.url }.asDriver(onErrorJustReturn: nil)
    }
    var items: Driver<[Any]> {
        return interactor.model.map { [weak self] model in
            return self?.mapModel(model) ?? []
        }
        .asDriver(onErrorJustReturn: [])
    }
    
    init(interactor: CharacterDetailFlowInteractable, router: CharacterDetailFlowRoutable) {
        self.interactor = interactor
        self.router = router
    }
    
    func start() {
        router.route(to: .start(preseter: self))
    }
    
    func handle(viewAction: CharacterDetailViewAction) {
        switch viewAction {
        case .openURL(let url):
            router.route(to: .showWebView(url: url))
        }
    }
}

private extension CharacterDetailFlowPresenter {
    func mapModel(_ model: Character) -> [Any] {
        var items: [Any] = []
        let title = TitleSectionItem(title: model.name, style: TitleCellStyle.title)
        items.append(title)
        let subtitle = TitleSectionItem(title: model.description, style: TitleCellStyle.subtitle)
        items.append(subtitle)
        items.append(contentsOf: mapLinks(from: model))
        return items
    }
    
    func mapLinks(from model: Character) -> [Any] {
        var items: [Any] = []
        let name: String = model.name
        for link in model.links {
            let title: String
            switch link.type {
            case .wiki:
                title = LocalizableString.wikiLink.localized(with: [name])
            case .comiclink:
                title = LocalizableString.comicsLink.localized(with: [name])
            case .detail:
                title = LocalizableString.detailLink.localized(with: [name])
            }
            let button = TitleSectionItem(title: title, style: TitleCellStyle.button, action: link.url)
            items.append(button)
        }
        return items
    }
}
