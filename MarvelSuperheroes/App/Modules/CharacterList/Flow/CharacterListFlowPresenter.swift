//
//  CharacterListFlowPresenter.swift
//  MarvelSuperheroes
//
//  Created by Arturo Murillo on 2/20/22.
//

import RxSwift
import RxCocoa

enum CharacterListFlowPresenterState {
    case isLoading(Bool)
    case reload(items: [CharacterSectionItem], isFirstPage: Bool)
}
 
struct CharacterSectionItem {
    var name: String
    var image: URL?
}

protocol CharacterListFlowPresentable {
    var state: Driver<CharacterListFlowPresenterState> { get }
    var canLoadMore: Bool { get }
    func handle(action: CharacterListViewAction)
}

final class CharacterListFlowPresenter: CharacterListFlowPresentable {
    private var characters: CharacterList?
    private let interactor: CharacterListFlowInteractable
    private let router: CharacterListFlowRoutable
    private let stateSubject = BehaviorSubject<CharacterListFlowPresenterState>(value: .isLoading(true))
    private let disposeBag = DisposeBag()
    
    var canLoadMore: Bool {
        return interactor.canLoadMore
    }
    
    var state: Driver<CharacterListFlowPresenterState> {
        return stateSubject.asDriver(onErrorJustReturn: .isLoading(true))
    }
    
    init(interactor: CharacterListFlowInteractable, router: CharacterListFlowRoutable) {
        self.interactor = interactor
        self.router = router
        
        bind()
    }
    
    func start() {
        router.route(to: .start(presenter: self))
    }
    
    func handle(action: CharacterListViewAction) {
        switch action {
        case .loadMore:
            interactor.loadMore()
        case .filterBy(let text):
            interactor.filter(text)
        case .search(text: let text):
            interactor.search(text)
        case .didSelect(let index):
            guard let model = interactor.getCharacter(at: index) else { return }
            router.route(to: .showDetail(model: model))
        }
    }
    
    private func bind() {
        interactor
            .dataStream
            .subscribe(onNext: { [weak self] dataUpdate in
                let items = dataUpdate.items.map{ CharacterSectionItem(name: $0.name, image: $0.thumbnail.url) }
                self?.stateSubject.onNext(.reload(items: items, isFirstPage: dataUpdate.isFirstPage))
            }, onError: { [weak self] error in
                self?.router.route(to: .showError(error))
            })
            .disposed(by: disposeBag)
        interactor
            .isWorking
            .subscribe(onNext: { [weak self] isWorking in
                self?.stateSubject.onNext(.isLoading(isWorking))
            })
            .disposed(by: disposeBag)
    }
}
