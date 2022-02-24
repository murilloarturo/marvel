//
//  UIViewController+Utils.swift
//  MarvelSuperheroes
//
//  Created by Arturo Murillo on 2/22/22.
//

import UIKit

enum NavigationButtonLocation {
    case left
    case right
}

extension UIViewController {
    func setNavigationButton(title: String? = nil,
                             image: UIImage? = nil,
                             target: Any? = self,
                             action: Selector?,
                             location: NavigationButtonLocation) {
        let button: UIBarButtonItem
        if let title = title {
            button = UIBarButtonItem(title: title, style: .plain, target: target, action: action)
        } else {
            button = UIBarButtonItem(image: image, style: .plain, target: target, action: action)
        }
        switch location {
        case .left:
            navigationItem.leftBarButtonItem = button
        case .right:
            navigationItem.rightBarButtonItem = button
        }
    }
}
