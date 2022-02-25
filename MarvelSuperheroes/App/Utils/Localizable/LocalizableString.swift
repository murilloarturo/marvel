//
//  LocalizableString.swift
//  MarvelSuperheroes
//
//  Created by Arturo Murillo on 2/22/22.
//

import Foundation

enum LocalizableString: String {
    //Common
    case error
    case ok
    //Home
    case abc
    case superheroes
    case noHeroesFound
    //Detail
    case issue
    case comics
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
