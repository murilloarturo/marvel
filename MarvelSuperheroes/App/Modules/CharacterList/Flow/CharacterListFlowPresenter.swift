//
//  CharacterListFlowPresenter.swift
//  MarvelSuperheroes
//
//  Created by Arturo Murillo on 2/20/22.
//

import RxCocoa

struct CharacterSectionItem {
    var name: String
    var image: URL?
}

protocol CharacterListFlowPresentable {
    var items: Driver<[CharacterSectionItem]> { get }
    func handle(action: CharacterListViewAction)
}

final class CharacterListFlowPresenter: CharacterListFlowPresentable {
    private var characters: CharacterList?
    private let interactor: CharacterListFlowInteractable
    private let router: CharacterListFlowRoutable
    
    var items: Driver<[CharacterSectionItem]> {
        return interactor.data.map { data in
            return data.items.results.map{ CharacterSectionItem(name: $0.name, image: $0.thumbnail.path) }
        }.asDriver(onErrorJustReturn: [])
    }
    
    init(interactor: CharacterListFlowInteractable, router: CharacterListFlowRoutable) {
        self.interactor = interactor
        self.router = router
    }
    
    func start() {
        router.route(to: .start(presenter: self))
    }
    
    func handle(action: CharacterListViewAction) {
        switch action {
        case .didScrollToBottom:
            interactor.fetchMoreCharacters()
        }
    }
}
