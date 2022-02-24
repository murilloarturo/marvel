//
//  UICollectionView+Utils.swift
//  MarvelSuperheroes
//
//  Created by Arturo Murillo on 2/20/22.
//

import UIKit

extension UICollectionReusableView {
    static var reuseableIdentifier: String {
        return String(describing: self)
    }

    @objc func update(with item: Any?) { }
}

extension UICollectionView {
    func registerCell<T: UICollectionViewCell>(cellType: T.Type) {
        let reuseableIdentifier = cellType.reuseableIdentifier
        register(UINib(nibName: reuseableIdentifier, bundle: nil), forCellWithReuseIdentifier: reuseableIdentifier)
    }

    func registerSupplementaryView<T: UICollectionReusableView>(reusableViewType: T.Type, kind: String) {
        let reuseableIdentifier = reusableViewType.reuseableIdentifier
        register(UINib(nibName: reuseableIdentifier, bundle: nil),
                 forSupplementaryViewOfKind: kind,
                 withReuseIdentifier: reuseableIdentifier)
    }

    func dequeueCell<T: UICollectionViewCell>(cellType: T.Type, indexPath: IndexPath) -> T {
        let reuseableIdentifier = cellType.reuseableIdentifier
        guard let cell = dequeueReusableCell(withReuseIdentifier: reuseableIdentifier, for: indexPath) as? T else {
            return T()
        }
        return cell
    }

    func dequeueSupplementaryView<T: UICollectionReusableView>(reusableViewType: T.Type, ofKind kind: String, indexPath: IndexPath) -> T {
        let reuseableIdentifier = reusableViewType.reuseableIdentifier
        guard let view = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseableIdentifier, for: indexPath) as? T else {
            return T()
        }
        return view
    }

    func containsIndexPath(_ indexPath: IndexPath) -> Bool {
        return indexPath.section < numberOfSections && indexPath.row < numberOfItems(inSection: indexPath.section)
    }
}

extension UICollectionView {
    func scrollToTop() {
        let point = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(point, animated: true)
    }
}
