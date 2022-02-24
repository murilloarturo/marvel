//
//  UIView+Nib.swift
//  MarvelSuperheroes
//
//  Created by Arturo Murillo on 2/23/22.
//

import UIKit

extension UIView {
    static func loadFromNib<T: UIView>() -> T {
        let bundle = Bundle(for: T.self)
        let nibName = String(describing: T.self)
        let nib = UINib(nibName: nibName, bundle: bundle)
        if let view = nib.instantiate(withOwner: self, options: nil).first as? T {
            return view
        } else {
            return T(frame: .zero)
        }
    }
    
    func bindLayoutToSuperView() {
        guard let view = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0))
    }
    
    func setupShadow(color: UIColor, opacity: Float = 1, radius: CGFloat = 10, offset: CGSize = .zero) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.masksToBounds = false
    }
}
