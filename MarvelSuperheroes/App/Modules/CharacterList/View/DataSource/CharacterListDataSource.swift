//
//  CharacterListDataSource.swift
//  MarvelSuperheroes
//
//  Created by Arturo Murillo on 2/20/22.
//

import UIKit
import RxSwift
import RxCocoa

protocol CharacterListDataSourceDelegate: AnyObject {
    var canLoadMore: Bool { get }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    func loadMore()
}

final class CharacterListDataSource: NSObject {
    private var items: [CharacterSectionItem] = []
    weak var delegate: CharacterListDataSourceDelegate?
    weak var collectionView: UICollectionView? {
        didSet {
            setupCollectionView()
        }
    }
    
    func insertNewItems(_ newItems: [CharacterSectionItem]) {
        if items.isEmpty {
            appendNewItems(newItems)
            return
        }
        let hasToReloadOnly = newItems.count >= items.count
        if hasToReloadOnly {
            items = newItems
            collectionView?.reloadData()
        } else {
            var deleteIndexPaths: [IndexPath] = []
            for i in newItems.count...items.count - 1 {
                deleteIndexPaths.append(IndexPath(row: i, section: 0))
            }
            items = newItems
            collectionView?.performBatchUpdates({ [weak collectionView] in
                collectionView?.deleteItems(at: deleteIndexPaths)
            }, completion: { [weak self] _ in
                self?.collectionView?.reloadData()
            })
        }
    }
    
    func appendNewItems(_ newItems: [CharacterSectionItem]) {
        var indexPaths: [IndexPath] = []
        let currentIndex: Int = items.count
        newItems.enumerated().forEach { item in
            indexPaths.append(IndexPath(row: currentIndex + item.offset, section: 0))
        }
        items.append(contentsOf: newItems)
        collectionView?.performBatchUpdates({ [weak collectionView] in
            collectionView?.insertItems(at: indexPaths)
        }, completion: { [weak collectionView] _ in
            collectionView?.reloadData()
        })
    }
    
    private func setupCollectionView() {
        guard let collectionView = collectionView else { return }
        let cells: [UICollectionViewCell.Type] = [CharacterCell.self]
        for cellType in cells {
            collectionView.registerCell(cellType: cellType)
        }
        let reusableViews: [UICollectionReusableView.Type] = [LoaderFooterView.self, EmptyCell.self]
        for view in reusableViews {
            collectionView.registerSupplementaryView(reusableViewType: view, kind: UICollectionView.elementKindSectionFooter)
        }
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension CharacterListDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = items.count
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(cellType: CharacterCell.self, indexPath: indexPath)
        cell.update(with: items[safe: indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let canLoadMore = delegate?.canLoadMore ?? false
        if canLoadMore {
            let view = collectionView.dequeueSupplementaryView(reusableViewType: LoaderFooterView.self, ofKind: kind, indexPath: indexPath)
            return view
        } else {
            let cell = collectionView.dequeueSupplementaryView(reusableViewType: EmptyCell.self, ofKind: kind, indexPath: indexPath)
            cell.update(with: LocalizableString.noHeroesFound.localized)
            return cell
        }
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

extension CharacterListDataSource: UICollectionViewDelegateFlowLayout {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        delegate?.scrollViewWillBeginDragging(scrollView)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let canLoadMore = delegate?.canLoadMore ?? false
        if canLoadMore {
            return CGSize(width: collectionView.bounds.width, height: 40)
        } else if items.isEmpty {
            return CGSize(width: collectionView.bounds.width, height: 200)
        } else {
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width / 2) - 5, height: 200)
    }
}
