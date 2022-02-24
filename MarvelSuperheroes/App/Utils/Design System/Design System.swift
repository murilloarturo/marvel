//
//  Design System.swift
//  MarvelSuperheroes
//
//  Created by Arturo Murillo on 2/24/22.
//

import UIKit

final class DesignSystem {
    static func changeDarkMode() {
        guard let window = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window else { return }
        window.overrideUserInterfaceStyle = window.overrideUserInterfaceStyle.inverted()
    }
    
    enum Color {
        static let white: UIColor = {
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                return UIColor.white
            }
        }()
        static let label: UIColor = {
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                        if UITraitCollection.userInterfaceStyle == .dark {
                            return UIColor.white
                        } else {
                            return UIColor.black
                        }
                    }
        }()
        static let labelSelected: UIColor = {
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                if UITraitCollection.userInterfaceStyle == .dark {
                    return UIColor.black
                } else {
                    return UIColor.white
                }
            }
        }()
        static let separator: UIColor = UIColor.systemGray3
        static let background: UIColor = UIColor.systemGray6
        static let backgroundSelected: UIColor = UIColor.systemGray2
    }
    
    enum Font {
        static let title: UIFont = UIFont.boldSystemFont(ofSize: 24)
        static let subtitle: UIFont = UIFont.systemFont(ofSize: 16)
    }
}

private extension UIUserInterfaceStyle {
    func inverted() -> UIUserInterfaceStyle {
        switch self {
        case .light:
            return .dark
        case .dark:
            return .light
        case .unspecified:
            return UIScreen.main.traitCollection.userInterfaceStyle.inverted()
        @unknown default:
            return UIScreen.main.traitCollection.userInterfaceStyle.inverted()
        }
    }
}
