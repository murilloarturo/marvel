//
//  LocalizableString.swift
//  MarvelSuperheroes
//
//  Created by Arturo Murillo on 2/22/22.
//

import Foundation

enum LocalizableString: String {
    case abc
    case superheroes
    case noHeroesFound
    case comicsLink
    case detailLink
    case wikiLink
    
    var localized: String {
        return NSLocalizedString(rawValue, comment: "")
    }

    func localized(with arguments: [CVarArg]) -> String {
        return String(format: localized, arguments: arguments)
    }
}
