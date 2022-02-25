//
//  ComicCell.swift
//  MarvelSuperheroes
//
//  Created by Arturo Murillo on 2/24/22.
//

import UIKit

class ComicCell: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var numberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.6
        nameLabel.font = DesignSystem.Font.link
        nameLabel.textColor = DesignSystem.Color.label
        numberLabel.adjustsFontSizeToFitWidth = true
        numberLabel.minimumScaleFactor = 0.6
        numberLabel.font = DesignSystem.Font.link
        numberLabel.textColor = DesignSystem.Color.label
    }
    
    override func update(with item: Any?) {
        guard let comic = item as? Comic else { return }
        if let url = comic.image.url {
            imageView.findImage(url)
        } else {
            imageView.image = nil
        }
        nameLabel.text = comic.title
        numberLabel.text = "\(LocalizableString.issue.localized) \(comic.issueNumber)"
    }

}
