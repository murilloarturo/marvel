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
    func setupCustomBackButton() {
        let button = BlurredButton(frame: .zero)
        button.selector = #selector(didTapBackButton)
        button.setup(image: ImageCatalog.backButton.image)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    @objc func didTapBackButton() {
        if let navigation = navigationController {
            navigation.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    func setNavigationButton(title: String? = nil,
                             image: UIImage? = nil,
                             target: Any? = self,
                             action: Selector?,
                             location: NavigationButtonLocation) {
        let button: UIBarButtonItem
        if let title = title {
            button = UIBarButtonItem(title: title, style: .plain, target: target, action: action)
        } else {
            button = UIBarButtonItem(image: image?.withRenderingMode(.alwaysTemplate), style: .plain, target: target, action: action)
        }
        switch location {
        case .left:
            navigationItem.leftBarButtonItem = button
        case .right:
            navigationItem.rightBarButtonItem = button
        }
    }
}
