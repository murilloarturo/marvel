//
//  HorizontalCell.swift
//  MarvelSuperheroes
//
//  Created by Arturo Murillo on 2/24/22.
//

import UIKit

class HorizontalCell: UICollectionViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.font = DesignSystem.Font.title
        titleLabel.textColor = DesignSystem.Color.label
    }
    
    func update(title: String) {
        titleLabel.text = title
    }
}
