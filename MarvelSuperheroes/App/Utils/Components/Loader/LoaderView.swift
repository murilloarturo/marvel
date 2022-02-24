//
//  LoaderView.swift
//  MarvelSuperheroes
//
//  Created by Arturo Murillo on 2/24/22.
//

import UIKit

class LoaderView: UIView {
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    private static var tagID: Int = 404
    
    static func showOver(view: UIView, aboveSubview subview: UIView? = nil) {
        guard getLoaderView(from: view) == nil else { return }
        let loaderView: LoaderView = .loadFromNib()
        loaderView.tag = tagID
        loaderView.alpha = 0
        if let subview = subview {
            view.insertSubview(loaderView, aboveSubview: subview)
        } else {
            view.addSubview(loaderView)
        }
        loaderView.bindLayoutToSuperView()
        loaderView.activityIndicator.startAnimating()
        UIView.animate(withDuration: 0.2) { [weak loaderView] in
            loaderView?.alpha = 1
        }
    }
    
    static func hideFrom(view: UIView) {
        guard let loaderView = getLoaderView(from: view) else { return }
        UIView.animate(withDuration: 0.2) { [weak loaderView] in
            loaderView?.alpha = 0
        } completion: { [weak loaderView] _ in
            loaderView?.removeFromSuperview()
        }

    }
    
    private static func getLoaderView(from view: UIView) -> LoaderView? {
        return view.subviews.first(where: { $0.tag == tagID }) as? LoaderView
    }
}
