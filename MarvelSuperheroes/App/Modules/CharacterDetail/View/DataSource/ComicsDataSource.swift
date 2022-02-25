//
//  ComicsDataSource.swift
//  MarvelSuperheroes
//
//  Created by Arturo Murillo on 2/24/22.
//

import UIKit

final class ComicsDataSource: NSObject {
    var items: [Comic] = [] {
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
    
    func append(_ comics: [Comic]) {
        
    }
    
    private func setupCollectionView() {
        guard let collectionView = collectionView else { return }
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        let cells: [UICollectionViewCell.Type] = [ComicCell.self]
        for cellType in cells {
            collectionView.registerCell(cellType: cellType)
        }
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension ComicsDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
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
        let cell = collectionView.dequeueCell(cellType: ComicCell.self, indexPath: indexPath)
        cell.update(with: items[safe: indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = items[safe: indexPath.row] else { return }
        delegate?.didSelectAction(with: item.detail)
    }
}

extension ComicsDataSource: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxHeight: CGFloat = collectionView.bounds.height
        return CGSize(width: 100, height: maxHeight)
    }
}
