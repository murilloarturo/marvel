//
//  CharacterListFlowInteractor.swift
//  MarvelSuperheroes
//
//  Created by Arturo Murillo on 2/20/22.
//

import RxSwift
import RxCocoa

protocol CharacterListFlowInteractable {
    var data: Observable<CharacterList> { get }
    func fetchMoreCharacters()
}

final class CharacterListFlowInteractor: CharacterListFlowInteractable {
    private var offset: Int = 0
    private let limit: Int = 20
    private let server: CharacterServer
    private let dataSubject = BehaviorSubject<CharacterList?>(value: nil)
    private let disposeBag = DisposeBag()
    private var isBusy = false
    
    var data: Observable<CharacterList> {
        return dataSubject.asObservable().compactMap{ $0 }
    }
    
    init(server: CharacterServer = CharacterNetworker()) {
        self.server = server
        
        fetchMoreCharacters()
    }
    
    func fetchMoreCharacters() {
        guard !isBusy else { return }
        isBusy = true
        server
            .getCharacters(offset: offset, limit: limit)
            .subscribe(onSuccess: { [weak self] characters in
                self?.offset += characters.items.results.count
                self?.dataSubject.onNext(characters)
                self?.isBusy = false
            }, onFailure: { [weak self] error in
                print(error)
                self?.dataSubject.onError(error)
                self?.isBusy = false
            })
            .disposed(by: disposeBag)
    }
}
