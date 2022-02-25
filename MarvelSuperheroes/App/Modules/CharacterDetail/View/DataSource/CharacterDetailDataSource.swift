//
//  CharacterDetailDataSource.swift
//  MarvelSuperheroes
//
//  Created by Arturo Murillo on 2/24/22.
//

import UIKit
import RxSwift
import RxCocoa

protocol CharacterDetailDataSourceDelegate: AnyObject {
    func didSelectAction(with url: URL?)
}

final class CharacterDetailDataSource: NSObject {
    var items: [Any] = [] {
        didSet {
            collectionView?.reloadData()
        }
    }
    weak var delegate: CharacterDetailDataSourceDelegate?
    weak var collectionView: UICollectionView? {
        didSet {
            setupCollectionView()
        }
    }
    
    private func setupCollectionView() {
        guard let collectionView = collectionView else { return }
//        let layout = UICollectionViewFlowLayout()
//        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
//        layout.scrollDirection = .vertical
//        collectionView.collectionViewLayout = layout
//        collectionView.
        let cells: [UICollectionViewCell.Type] = [TitleCell.self]
        for cellType in cells {
            collectionView.registerCell(cellType: cellType)
        }
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension CharacterDetailDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = items.count
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(cellType: TitleCell.self, indexPath: indexPath)
        cell.update(with: items[safe: indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = items[safe: indexPath.row] else { return }
        switch item {
        case let sectionItem as TitleSectionItem where sectionItem.style == .button:
            delegate?.didSelectAction(with: sectionItem.action)
        default:
            break
        }
    }
}

extension CharacterDetailDataSource: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let item = items[safe: indexPath.row] else {
            return .zero
        }
        let maxWidth: CGFloat = collectionView.bounds.width
        switch item {
        case let sectionItem as TitleSectionItem:
            return sectionItemSize(item: sectionItem, maxWidth: maxWidth)
        default:
            return .zero
        }
    }
    
    func sectionItemSize(item: TitleSectionItem, maxWidth: CGFloat) -> CGSize {
        switch item.style {
        case .button:
            return CGSize(width: maxWidth, height: 50)
        default:
            let padding: CGFloat = 20
            let height: CGFloat = item.title.height(withConstrainedWidth: maxWidth - padding, font: item.style.font)
            return CGSize(width: maxWidth, height: height + padding)
        }
    }
}
