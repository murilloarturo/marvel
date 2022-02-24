//
//  ImageFinder.swift
//  MarvelSuperheroes
//
//  Created by Arturo Murillo on 2/24/22.
//

import UIKit

enum ImageCatalog: String {
    case backButton
    case filter
    case darkMode
    
    var image: UIImage? {
        return UIImage(named: rawValue)
    }
}
