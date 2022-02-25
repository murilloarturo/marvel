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
    case button
    case copyright
    
    var font: UIFont {
        switch self {
        case .title:
            return DesignSystem.Font.title
        case .subtitle:
            return DesignSystem.Font.subtitle
        case .button, .copyright:
            return DesignSystem.Font.link
        }
    }
}

struct TitleSectionItem {
    var title: String
    var style: TitleCellStyle
    var action: URL?
}

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
        switch text.style {
        case .button:
            label.textColor = DesignSystem.Color.link
            label.textAlignment = .center
        case .copyright:
            label.textColor = DesignSystem.Color.label
            label.textAlignment = .center
        default:
            label.textColor = DesignSystem.Color.label
            label.textAlignment = .justified
        }
    }
}
