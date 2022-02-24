//
//  LoaderFooterView.swift
//  MarvelSuperheroes
//
//  Created by Arturo Murillo on 2/20/22.
//

import UIKit

class LoaderFooterView: UICollectionReusableView {
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    func animate(_ animate: Bool) {
        animate ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
}
