//
//  CharacterCell.swift
//  MarvelSuperheroes
//
//  Created by Arturo Murillo on 2/20/22.
//

import UIKit

class CharacterCell: UICollectionViewCell {
    @IBOutlet private weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .black
    }

    override func update(with item: Any?) {
        guard let item = item as? CharacterSectionItem else { return }
        nameLabel.text = item.name
    }
}
