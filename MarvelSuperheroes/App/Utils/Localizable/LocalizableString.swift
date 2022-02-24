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
    
    var localized: String {
        return NSLocalizedString(rawValue, comment: "")
    }

    func localized(arguments: CVarArg...) -> String {
        return String(format: localized, arguments)
    }
}
