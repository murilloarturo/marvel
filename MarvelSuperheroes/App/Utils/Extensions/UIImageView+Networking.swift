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
        
//        AF.request(url)
//            .responseImage { response in
//                guard case .success(let image) = response.result else { return }
//                self.image = image
//            }
    }
}
