//
//  EmptyCell.swift
//  MarvelSuperheroes
//
//  Created by Arturo Murillo on 2/22/22.
//

import UIKit

class EmptyCell: UICollectionViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    
    override func update(with item: Any?) {
        guard let title = item as? String else { return }
        titleLabel.text = title
    }
}
