//
//  WebViewController.swift
//  MarvelSuperheroes
//
//  Created by Arturo Murillo on 2/24/22.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    private weak var activityIndicator: UIActivityIndicatorView?
    private let url: URL
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        activityIndicator?.startAnimating()
    }
    
    private func setup() {
        let webView = WKWebView(frame: .zero)
        webView.navigationDelegate = self
        view.addSubview(webView)
        webView.bindLayoutToSuperView()
        
        let request = URLRequest(url: url)
        webView.load(request)
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        view.addSubview(activityIndicator)
        activityIndicator.bindCenter()
        
        self.activityIndicator = activityIndicator
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activityIndicator?.isHidden = true
    }
}
