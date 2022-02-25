//
//  FilterCell.swift
//  MarvelSuperheroes
//
//  Created by Arturo Murillo on 2/23/22.
//

import UIKit

class FilterCell: UICollectionViewCell {
    @IBOutlet private weak var separatorView: UIView!
    @IBOutlet private weak var filterLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        separatorView.backgroundColor = DesignSystem.Color.separator
    }
    
    override func update(with item: Any?) {
        guard let item = item as? FilterSectionItem else { return }
        filterLabel.text = item.filter
        filterLabel.textColor = item.isSelected ? DesignSystem.Color.labelSelected : DesignSystem.Color.label
        backgroundColor = item.isSelected ? DesignSystem.Color.backgroundSelected : DesignSystem.Color.background
    }
}