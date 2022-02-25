//
//  CharacterDetailFlowInteractor.swift
//  MarvelSuperheroes
//
//  Created by Arturo Murillo on 2/24/22.
//

import Foundation
import RxSwift

typealias ComicsUpdate = (items: [Comic], isFirstPage: Bool)
typealias ComicsResponse = ServerResponse<Comic>

protocol CharacterDetailFlowInteractable {
    var model: Observable<Character> { get }
    var comics: Observable<ComicsUpdate> { get }
    var canLoadMore: Bool { get }
    
    var copyrightText: String? { get }
    func loadMore()
}

final class CharacterDetailFlowInteractor: CharacterDetailFlowInteractable {
    private let disposeBag = DisposeBag()
    private let character: Character
    private var response: ComicsResponse?
    private let modelSubject = BehaviorSubject<Character?>(value: nil)
    private let comicsSubject = BehaviorSubject<ComicsUpdate?>(value: nil)
    @Dependency
    private var networker: EndpointRequester?
    var model: Observable<Character> {
        return modelSubject.asObservable().compactMap{ $0 }
    }
    var comics: Observable<ComicsUpdate> {
        return comicsSubject.compactMap{ $0 }
    }
    var canLoadMore: Bool {
        return networker?.canLoadMore ?? false
    }
    var copyrightText: String? {
        return response?.copyright ?? ""
    }
    
    init(character: Character) {
        self.character = character
        
        modelSubject.onNext(character)
        requestNewPageOfComics()
    }
    
    func loadMore() {
        requestNewPageOfComics()
    }
}

private extension CharacterDetailFlowInteractor {
    func getEndpoint() -> ServerEndpoint {
        let id = "\(character.id)"
        return .comics(characterId: id)
    }
    
    func getQueryParameter() -> [String: Any] {
        return [:]
    }
    
    func requestNewPageOfComics() {
        networker?
            .fetchData(Comic.self, endpoint: getEndpoint(), params: getQueryParameter())
            .subscribe(onSuccess: { [weak self] response in
                guard let self = self else { return }
                self.updateResponse(response)
            }, onFailure: { [weak self] error in
                self?.comicsSubject.onError(error)
            })
            .disposed(by: disposeBag)
    }
    
    func updateResponse(_ response: ComicsResponse) {
        if self.response == nil {
            self.response = response
            comicsSubject.onNext((response.items.results, true))
        } else {
            self.response?.items.append(collection: response.items)
            comicsSubject.onNext((response.items.results, false))
        }
    }
}
