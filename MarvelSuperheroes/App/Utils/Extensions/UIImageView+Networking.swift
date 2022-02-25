//
//  UIImageView+Networking.swift
//  MarvelSuperheroes
//
//  Created by Arturo Murillo on 2/24/22.
//

import UIKit
import Nuke

extension UIImageView {
    func findImage(_ url: URL) {
        Nuke.loadImage(with: url, into: self)
    }
}
