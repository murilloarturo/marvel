//
//  CharacterCell.swift
//  MarvelSuperheroes
//
//  Created by Arturo Murillo on 2/20/22.
//

import UIKit

class CharacterCell: UICollectionViewCell {
    @IBOutlet private weak var labelContainerView: UIView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.image = nil
    }

    override func update(with item: Any?) {
        guard let item = item as? CharacterSectionItem else { return }
        nameLabel.text = item.name
        if let url = item.image {
            imageView.findImage(url)
        }
    }
    
    private func setup() {
        backgroundColor = DesignSystem.Color.background
        nameLabel.textColor = DesignSystem.Color.label
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.2
        if !UIAccessibility.isReduceTransparencyEnabled {
            labelContainerView.backgroundColor = .clear
            let blurEffect = UIBlurEffect(style: .regular)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = labelContainerView.bounds
            labelContainerView.insertSubview(blurEffectView, at: 0)
            blurEffectView.bindLayoutToSuperView()
        } else {
            labelContainerView.backgroundColor = DesignSystem.Color.background
        }
    }
}
