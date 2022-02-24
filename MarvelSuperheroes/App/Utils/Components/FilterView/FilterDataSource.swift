//
//  FilterDataSource.swift
//  MarvelSuperheroes
//
//  Created by Arturo Murillo on 2/23/22.
//

import UIKit
import RxSwift

typealias FilterSectionItem = (filter: String, isSelected: Bool)

final class FilterDataSource: NSObject {
    private var selectedIndex: IndexPath?
    let filterSelectionSubject = PublishSubject<String?>()
    weak var collectionView: UICollectionView? {
        didSet {
            setupCollectionView()
        }
    }
    var items: [String] = [] {
        didSet {
            collectionView?.reloadData()
        }
    }
    
    func selectItem(at index: Int?) {
        if let index = index {
            selectedIndex = IndexPath(row: index, section: 0)
        } else {
            selectedIndex = nil
        }
        collectionView?.reloadData()
    }
    
    private func setupCollectionView() {
        guard let collectionView = collectionView else { return }
        collectionView.registerCell(cellType: FilterCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension FilterDataSource: UICollectionViewDataSource {
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
        let cell = collectionView.dequeueCell(cellType: FilterCell.self, indexPath: indexPath)
        if let filter = items[safe: indexPath.row] {
            let item: FilterSectionItem = (filter, selectedIndex == indexPath)
            cell.update(with: item)
        }
        cell.update(with: items[safe: indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let filter = items[safe: indexPath.row] else { return }
        if selectedIndex == indexPath {
            selectedIndex = nil
            filterSelectionSubject.onNext(nil)
        } else {
            selectedIndex = indexPath
            filterSelectionSubject.onNext(filter)
        }
        collectionView.reloadData()
    }
}

extension FilterDataSource: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
}
