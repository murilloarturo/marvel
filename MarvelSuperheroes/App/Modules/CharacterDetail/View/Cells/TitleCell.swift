//
//  TitleCell.swift
//  MarvelSuperheroes
//
//  Created by Arturo Murillo on 2/24/22.
//

import UIKit

enum TitleCellStyle {
    case title
    case subtitle
    
    var font: UIFont {
        switch self {
        case .title:
            return DesignSystem.Font.title
        case .subtitle:
            return DesignSystem.Font.subtitle
        }
    }
}

typealias TitleSectionItem = (title: String, style: TitleCellStyle)

class TitleCell: UICollectionViewCell {
    @IBOutlet private weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        label.textColor = DesignSystem.Color.label
    }
    
    override func update(with item: Any?) {
        guard let text = item as? TitleSectionItem else { return }
        label.text = text.title
        label.font = text.style.font
    }
}
