//
//  CharacterListFlowInteractor.swift
//  MarvelSuperheroes
//
//  Created by Arturo Murillo on 2/20/22.
//

import RxSwift
import RxCocoa

typealias CharacterListUpdate = (items: [Character], isFirstPage: Bool)
typealias CharacterResponse = ServerResponse<Character>

protocol CharacterListFlowInteractable {
    var dataStream: Observable<CharacterListUpdate> { get }
    var isWorking: Observable<Bool> { get }
    var canLoadMore: Bool { get }
        
    func getCharacter(at index: Int) -> Character?
    func loadMore()
    func filter(_ text: String?)
    func search(_ text: String?)
}

final class CharacterListFlowInteractor: CharacterListFlowInteractable {
    private var isBusy = BehaviorRelay<Bool>(value: false)
    private var queryString: String?
    private var startingByString: String?
    private var data: CharacterResponse?
    private let disposeBag = DisposeBag()
    private var dataStreamSubject = BehaviorSubject<CharacterListUpdate>(value: ([], false))
    @Dependency
    private var networker: EndpointRequester?
    var canLoadMore: Bool {
        return networker?.canLoadMore ?? false
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
        requestNewPageOfCharacters()
    }
    
    func filter(_ text: String?) {
        queryString = nil
        startingByString = text
        requestFirstPage()
    }
    
    func search(_ text: String?) {
        let newText = text ?? ""
        queryString = newText.isEmpty ? nil : newText
        startingByString = nil
        requestFirstPage()
    }
    
    func getCharacter(at index: Int) -> Character? {
        return data?.items.results[safe: index]
    }
}

private extension CharacterListFlowInteractor {
    func getEndpoint() -> ServerEndpoint {
        return .characters
    }
    
    func getQueryParameter() -> [String: Any] {
        var parameters: [String: Any] = ["orderBy": "name"]
        let query = queryString ?? startingByString ?? ""
        if !query.isEmpty {
            parameters["nameStartsWith"] = query
        }
        return parameters
    }
    
    func requestFirstPage() {
        isBusy.accept(true)
        data = nil
        networker = DependencyContainer.resolve()
        requestNewPageOfCharacters()
    }
    
    func requestNewPageOfCharacters() {
        guard canLoadMore else { return }
        networker?
            .fetchData(Character.self, endpoint: getEndpoint(), params: getQueryParameter())
            .subscribe(onSuccess: { [weak self] characters in
                guard let self = self else { return }
                self.updateResponse(characters)
                self.isBusy.accept(false)
            }, onFailure: { [weak self] error in
                self?.dataStreamSubject.onError(error)
                self?.isBusy.accept(false)
            })
            .disposed(by: disposeBag)
    }
    
    func updateResponse(_ response: CharacterResponse) {
        if self.data == nil {
            self.data = response
            dataStreamSubject.onNext((response.items.results, true))
        } else {
            self.data?.items.append(collection: response.items)
            dataStreamSubject.onNext((response.items.results, false))
        }
    }
}
