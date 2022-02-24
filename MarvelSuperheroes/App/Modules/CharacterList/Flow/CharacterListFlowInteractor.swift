//
//  CharacterListFlowInteractor.swift
//  MarvelSuperheroes
//
//  Created by Arturo Murillo on 2/20/22.
//

import RxSwift
import RxCocoa

typealias CharacterListUpdate = (items: [Character], isFirstPage: Bool)

protocol CharacterListFlowInteractable {
    var dataStream: Observable<CharacterListUpdate> { get }
    var isWorking: Observable<Bool> { get }
    var canLoadMore: Bool { get }
        
    func loadMore()
    func filter(_ text: String?)
    func search(_ text: String?)
}

final class CharacterListFlowInteractor: CharacterListFlowInteractable {
    private var isBusy = BehaviorRelay<Bool>(value: false)
    private var queryString: String?
    private var startingByString: String?
    private var data: CharacterList?
    private let disposeBag = DisposeBag()
    private var dataStreamSubject = BehaviorSubject<CharacterListUpdate>(value: ([], false))
    @Dependency private var server: CharacterServer?
    var canLoadMore: Bool {
        return server?.canLoadMore ?? false
    }
    var dataStream: Observable<CharacterListUpdate> {
        return dataStreamSubject.asObservable()
    }
    var isWorking: Observable<Bool> {
        return isBusy.asObservable()
    }
    
    init() {
        requestNewPageOfCharacters()
    }
    
    func loadMore() {
        requestMoreCharacters()
    }
    
    func filter(_ text: String?) {
        queryString = nil
        startingByString = text
        requestNewPageOfCharacters()
    }
    
    func search(_ text: String?) {
        let newText = text ?? ""
        queryString = newText.isEmpty ? nil : newText
        requestNewPageOfCharacters()
    }
}

private extension CharacterListFlowInteractor {
    func getQueryParameter() -> String {
        return queryString ?? startingByString ?? ""
    }
    
    func requestNewPageOfCharacters() {
        isBusy.accept(true)
        server = DependencyContainer.resolve()
        server?
            .getCharacters(withQuery: getQueryParameter())
            .subscribe(onSuccess: { [weak self] characters in
                guard let self = self else { return }
                self.data = characters
                self.dataStreamSubject.onNext((characters.items.results, true))
                self.isBusy.accept(false)
            }, onFailure: { [weak self] error in
                self?.dataStreamSubject.onError(error)
                self?.isBusy.accept(false)
            })
            .disposed(by: disposeBag)
    }
    
    func requestMoreCharacters() {
        guard canLoadMore else { return }
        server?
            .getCharacters(withQuery: getQueryParameter())
            .subscribe(onSuccess: { [weak self] characters in
                guard let self = self else { return }
                self.data?.items.append(collection: characters.items)
                self.dataStreamSubject.onNext((characters.items.results, false))
            }, onFailure: { [weak self] error in
                self?.dataStreamSubject.onError(error)
            })
            .disposed(by: disposeBag)
    }
    
//    private func search(text: String, from server: CharacterServer?) {
//        guard !isBusy.value && !text.isEmpty else { return }
//        isBusy.accept(true)
//        server?
//            .getCharacters(withQuery: text)
//            .subscribe(onSuccess: { [weak self] characters in
//                guard let self = self else { return }
//                self.dataStreamSubject.onNext((characters.items.results, false))
//                self.isBusy.accept(false)
//            }, onFailure: { [weak self] error in
//                self?.dataStreamSubject.onError(error)
//                self?.isBusy.accept(false)
//            })
//            .disposed(by: disposeBag)
//    }
}
