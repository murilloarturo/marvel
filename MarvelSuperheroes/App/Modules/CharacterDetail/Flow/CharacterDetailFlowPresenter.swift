//
//  CharacterDetailFlowPresenter.swift
//  MarvelSuperheroes
//
//  Created by Arturo Murillo on 2/24/22.
//

import Foundation
import RxSwift
import RxCocoa

protocol CharacterDetailFlowPresentable {
    var canLoadMore: Bool { get }
    var characterImage: Driver<URL?> { get }
    var items: Driver<[Any]> { get }
    var newComics: Driver<[Comic]> { get }
    
    func handle(viewAction: CharacterDetailViewAction)
}

final class CharacterDetailFlowPresenter: CharacterDetailFlowPresentable {
    private let interactor: CharacterDetailFlowInteractable
    private let router: CharacterDetailFlowRoutable
    private let disposeBag = DisposeBag()
    private let itemsSubject = BehaviorRelay<[Any]>(value: [])
    var characterImage: Driver<URL?> {
        return interactor.model.map{ $0.thumbnail.url }.asDriver(onErrorJustReturn: nil)
    }
    var items: Driver<[Any]> {
        return itemsSubject.asDriver(onErrorJustReturn: [])
    }
    var canLoadMore: Bool {
        return interactor.canLoadMore
    }
    var newComics: Driver<[Comic]> {
        return interactor.comics.filter{ !$0.isFirstPage }.map{ $0.items }.asDriver(onErrorJustReturn: [])
    }
    
    init(interactor: CharacterDetailFlowInteractable, router: CharacterDetailFlowRoutable) {
        self.interactor = interactor
        self.router = router
        
        bind()
    }
    
    func start() {
        router.route(to: .start(preseter: self))
    }
    
    func handle(viewAction: CharacterDetailViewAction) {
        switch viewAction {
        case .openURL(let url):
            router.route(to: .showWebView(url: url))
        case .loadMore:
            interactor.loadMore()
        }
    }
}

private extension CharacterDetailFlowPresenter {
    func bind() {
        Observable.combineLatest(interactor.model, interactor.comics.take(1))
            .subscribe(onNext: { [weak self] items in
                self?.mapModel(items.0, comics: items.1)
            }, onError: { [weak self] error in
                self?.router.route(to: .showError(error))
            })
            .disposed(by: disposeBag)
    }
    
    func mapModel(_ model: Character, comics: ComicsUpdate) {
        var items: [Any] = []
        let title = TitleSectionItem(title: model.name, style: TitleCellStyle.title)
        items.append(title)
        let subtitle = TitleSectionItem(title: model.description, style: TitleCellStyle.subtitle)
        items.append(subtitle)
        if comics.isFirstPage && !comics.items.isEmpty {
            items.append(comics.items)
        }
        items.append(contentsOf: mapLinks(from: model))
        if let copyRight = interactor.copyrightText {
            items.append(TitleSectionItem(title: copyRight, style: .copyright))
        }
        
        itemsSubject.accept(items)
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
            default:
                title = LocalizableString.detailLink.localized(with: [name])
            }
            let button = TitleSectionItem(title: title, style: TitleCellStyle.button, action: link.url)
            items.append(button)
        }
        return items
    }
}
