//
//  CharacterListDataSource.swift
//  MarvelSuperheroes
//
//  Created by Arturo Murillo on 2/20/22.
//

import UIKit
import RxSwift
import RxCocoa

final class CharacterListDataSource: NSObject {
    private var items: [CharacterSectionItem] = []
    let actionSubject = PublishSubject<CharacterListViewAction>()
    weak var collectionView: UICollectionView? {
        didSet {
            setupCollectionView()
        }
    }
    
    func insertNewItems(_ newItems: [CharacterSectionItem]) {
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
        collectionView.registerSupplementaryView(reusableViewType: LoaderFooterView.self, kind: UICollectionView.elementKindSectionFooter)
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
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(cellType: CharacterCell.self, indexPath: indexPath)
        cell.update(with: items[safe: indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueSupplementaryView(reusableViewType: LoaderFooterView.self, ofKind: kind, indexPath: indexPath)
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == items.count - 10 {
            print("fetch next page")
            actionSubject.onNext(.didScrollToBottom)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            print("did scroll to bottom")
//            delegate?.didScrollToBottom()
            actionSubject.onNext(.didScrollToBottom)
        }
    }
}

extension CharacterListDataSource: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width / 2) - 5, height: 200)
    }
}
