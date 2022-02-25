//
//  CharacterDetailViewController.swift
//  MarvelSuperheroes
//
//  Created by Arturo Murillo on 2/24/22.
//

import UIKit
import RxSwift

enum CharacterDetailViewAction {
    case openURL(URL)
    case loadMore
}

class CharacterDetailViewController: UIViewController {
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var collectionView: UICollectionView!
    private let dataSource = CharacterDetailDataSource()
    private let disposeBag = DisposeBag()
    private let presenter: CharacterDetailFlowPresentable
    
    init(presenter: CharacterDetailFlowPresentable, bundle: Bundle? = Bundle.main) {
        self.presenter = presenter
        super.init(nibName: String(describing: CharacterDetailViewController.self), bundle: bundle)
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
        
        navigationController?.navigationBar.tintColor = DesignSystem.Color.label
    }
}

private extension CharacterDetailViewController {
    func setup() {
        activityIndicator.startAnimating()
        imageView.setupRoundCorners(radius: 40, corners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
        dataSource.collectionView = collectionView
        dataSource.delegate = self
        bind()
//        setupCustomBackButton()
    }
    
    func bind() {
        presenter
            .characterImage
            .drive(onNext: { [weak self] url in
                guard let url = url else { return }
                self?.imageView.findImage(url)
            })
            .disposed(by: disposeBag)
        presenter
            .items
            .skip(1)
            .do(onNext: { [weak self] _ in
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.isHidden = true
            })
            .drive(onNext: { [weak self] items in
                self?.dataSource.items = items
            })
            .disposed(by: disposeBag)
        presenter
            .newComics
            .drive(onNext: { [weak self] comics in
                self?.dataSource.addComics(comics)
            })
            .disposed(by: disposeBag)
    }
}

extension CharacterDetailViewController: CharacterDetailDataSourceDelegate {
    var canLoadMore: Bool {
        return presenter.canLoadMore
    }
    
    func loadMore() {
        presenter.handle(viewAction: .loadMore)
    }
    
    func didSelectAction(with url: URL?) {
        guard let url = url else { return }
        presenter.handle(viewAction: .openURL(url))
    }
}
