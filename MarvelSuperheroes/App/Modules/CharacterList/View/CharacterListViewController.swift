//
//  CharacterListViewController.swift
//  MarvelSuperheroes
//
//  Created by Arturo Murillo on 2/20/22.
//

import UIKit
import RxSwift
import RxCocoa

enum CharacterListViewAction {
    case didScrollToBottom
}

class CharacterListViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    private let dataSource = CharacterListDataSource()
    private let disposeBag = DisposeBag()
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

        setup()
    }
}

private extension CharacterListViewController {
    func setup() {
        title = "Characters"
        navigationController?.navigationBar.prefersLargeTitles = true
        dataSource.collectionView = collectionView
        bind()
    }
    
    func bind() {
        presenter
            .items
            .drive(onNext: { [weak self] items in
                self?.dataSource.insertNewItems(items)
            })
            .disposed(by: disposeBag)
        dataSource
            .actionSubject
            .subscribe(onNext: { [weak self] action in
                self?.presenter.handle(action: action)
            })
            .disposed(by: disposeBag)
    }
}
