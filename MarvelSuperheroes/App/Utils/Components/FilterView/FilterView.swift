//
//  FilterView.swift
//  MarvelSuperheroes
//
//  Created by Arturo Murillo on 2/23/22.
//

import UIKit
import RxSwift

class FilterView: UIView {
    @IBOutlet private weak var collectionView: UICollectionView!
    fileprivate let dataSource = FilterDataSource()
    
    enum Config {
        case abc
        
        var items: [String] {
            switch self {
            case .abc:
                return String.ABC()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    func setup(with config: Config) {
        dataSource.items = config.items
    }
    
    func selectFilter(at index: Int?) {
        dataSource.selectItem(at: index)
    }
    
    private func setup() {
        dataSource.collectionView = collectionView
    }
}

extension Reactive where Base: FilterView {
    var selectedFilter: Observable<String?> {
        base.dataSource.filterSelectionSubject.asObservable()
    }
}

extension String {
    static func ABC() -> [String] {
        var items: [String] = []
        let startingValue = Int(("A" as UnicodeScalar).value) // 65
        for i in 0 ..< 26 {
            if let code = UnicodeScalar(i + startingValue) {
                items.append(String(code))
            }
        }
        return items
    }
}
