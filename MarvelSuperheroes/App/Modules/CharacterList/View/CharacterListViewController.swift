//
//  CharacterListViewController.swift
//  MarvelSuperheroes
//
//  Created by Arturo Murillo on 2/20/22.
//

import UIKit

class CharacterListViewController: UIViewController {
    private let presenter: CharacterListFlowPresentable
    
    init(presenter: CharacterListFlowPresentable, bundle: Bundle? = Bundle.main) {
        self.presenter = presenter
        super.init(nibName: String(describing: CharacterListViewController.self), bundle: bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}
