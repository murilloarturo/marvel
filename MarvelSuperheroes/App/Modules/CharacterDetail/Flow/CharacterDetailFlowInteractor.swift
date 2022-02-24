//
//  CharacterDetailFlowInteractor.swift
//  MarvelSuperheroes
//
//  Created by Arturo Murillo on 2/24/22.
//

import Foundation
import RxSwift

protocol CharacterDetailFlowInteractable {
    var model: Observable<Character> { get }
    var comics: Observable<[Comic]> { get }
}

final class CharacterDetailFlowInteractor: CharacterDetailFlowInteractable {
    private let character: Character
    private let modelSubject = BehaviorSubject<Character?>(value: nil)
    private let comicsSubject = BehaviorSubject<[Comic]>(value: [])
    var model: Observable<Character> {
        return modelSubject.asObservable().compactMap{ $0 }
    }
    var comics: Observable<[Comic]> {
        return comicsSubject.asObservable()
    }
    
    init(character: Character) {
        self.character = character
        
        modelSubject.onNext(character)
    }
}
