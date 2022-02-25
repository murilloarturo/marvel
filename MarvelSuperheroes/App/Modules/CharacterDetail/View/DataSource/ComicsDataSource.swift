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
        var indexPaths: [IndexPath] = []
        let currentIndex: Int = items.count
        comics.enumerated().forEach { item in
            indexPaths.append(IndexPath(row: currentIndex + item.offset, section: 0))
        }
        collectionView?.performBatchUpdates({ [weak collectionView, weak self] in
            collectionView?.insertItems(at: indexPaths)
            self?.items.append(contentsOf: comics)
        }, completion: { [weak collectionView] _ in
            collectionView?.reloadData()
        })
    }
    
    private func setupCollectionView() {
        guard let collectionView = collectionView else { return }
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        let cells: [UICollectionViewCell.Type] = [ComicCell.self]
        for cellType in cells {
            collectionView.registerCell(cellType: cellType)
        }
        let reusableViews: [UICollectionReusableView.Type] = [LoaderFooterView.self]
        for view in reusableViews {
            collectionView.registerSupplementaryView(reusableViewType: view, kind: UICollectionView.elementKindSectionFooter)
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueSupplementaryView(reusableViewType: LoaderFooterView.self, ofKind: kind, indexPath: indexPath)
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == items.count - 10 {
            delegate?.loadMore()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if let loaderView = view as? LoaderFooterView {
            loaderView.animate(true)
        }
    }
}

extension ComicsDataSource: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxHeight: CGFloat = collectionView.bounds.height
        return CGSize(width: 100, height: maxHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let canLoadMore = delegate?.canLoadMore ?? false
        if canLoadMore {
            return CGSize(width: 40, height: collectionView.bounds.width)
        } else {
            return .zero
        }
    }
}
