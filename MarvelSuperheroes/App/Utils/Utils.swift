//
//  Utils.swift
//  MarvelSuperheroes
//
//  Created by Arturo Murillo on 2/20/22.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
