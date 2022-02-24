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
}

final class CharacterDetailFlowPresenter: CharacterDetailFlowPresentable {
    private let interactor: CharacterDetailFlowInteractable
    private let router: CharacterDetailFlowRoutable
    var characterImage: Driver<URL?> {
        return interactor.model.map{ $0.thumbnail.url }.asDriver(onErrorJustReturn: nil)
    }
    var items: Driver<[Any]> {
        return interactor.model.map { model in
            var items: [Any] = []
            let title: TitleSectionItem = (model.name, TitleCellStyle.title)
            items.append(title)
            let subtitle: TitleSectionItem = (model.description, TitleCellStyle.subtitle)
            items.append(subtitle)
            return items
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
}
