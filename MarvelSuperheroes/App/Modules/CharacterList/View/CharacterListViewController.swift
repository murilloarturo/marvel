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
    case loadMore
    case search(text: String?)
    case filterBy(text: String?)
}

class CharacterListViewController: UIViewController {
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var filterContainerView: UIView!
    @IBOutlet private weak var filterTrailingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var collectionView: UICollectionView!
    private let filterView: FilterView = .loadFromNib()
    private var lastContentOffset: CGFloat = 0
    private let dataSource = CharacterListDataSource()
    private let filterDataSource = CharacterListDataSource()
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
    var filterWidth: CGFloat {
        return filterContainerView.bounds.width
    }
    
    var isShowingFitlerView: Bool {
        return filterTrailingConstraint.constant == 0
    }
    
    func setup() {
        navigationController?.navigationBar.tintColor = UIColor.black
        filterContainerView.setupShadow(color: UIColor.black, opacity: 0.3, radius: 6, offset: CGSize(width: -6, height: 6))
        filterView.setup(with: .abc)
        filterContainerView.addSubview(filterView)
        filterView.bindLayoutToSuperView()
        dataSource.delegate = self
        hideFilterView(animated: false)
        title = LocalizableString.superheroes.localized
        dataSource.collectionView = collectionView
        setupNavigationItem()
        bind()
    }
    
    func bind() {
        presenter
            .state
            .drive(onNext: { [weak self] state in
                self?.handlePresenterState(state)
            })
            .disposed(by: disposeBag)
        filterView
            .rx.selectedFilter
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] filter in
                guard let self = self else { return }
                self.presenter.handle(action: .filterBy(text: filter))
                self.hideFilterView(animated: true)
                self.searchBar.text = nil
                self.searchBar.resignFirstResponder()
            })
            .disposed(by: disposeBag)
        searchBar
            .rx.text
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] text in
                guard let self = self else { return }
                self.presenter.handle(action: .search(text: text))
                self.hideFilterView(animated: true)
                self.filterView.selectFilter(at: nil)
            })
            .disposed(by: disposeBag)
    }
    
    func handlePresenterState(_ state: CharacterListFlowPresenterState) {
        switch state {
        case .isLoading(let isLoading):
            let delay: Double = isLoading ? 0 : 0.5
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                self?.showLoader(show: isLoading)
            }
        case .reload(let items, let isFirstPage):
            if isFirstPage {
                collectionView.scrollToTop()
                dataSource.insertNewItems(items)
            } else {
                dataSource.appendNewItems(items)
            }
        }
    }
    
    func setupNavigationItem() {
        let button = UIBarButtonItem(image: ImageCatalog.filter.image?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(didTapFilter))
        navigationItem.rightBarButtonItem = button
    }
    
    @objc func didTapFilter(_ button: UIBarButtonItem) {
        isShowingFitlerView ? hideFilterView(animated: true) : showFilterView(animated: true)
    }
    
    func showLoader(show: Bool) {
        if show {
            LoaderView.showOver(view: view, aboveSubview: collectionView)
        } else {
            LoaderView.hideFrom(view: view)
        }
    }
    
    func showFilterView(animated: Bool) {
        guard !isShowingFitlerView else { return }
        updateFilterViewLayout(trailing: 0, animated: animated)
    }
    
    func hideFilterView(animated: Bool) {
        guard isShowingFitlerView else { return }
        updateFilterViewLayout(trailing: -(filterWidth * 2), animated: animated)
    }
    
    func updateFilterViewLayout(trailing: CGFloat, animated: Bool) {
        filterTrailingConstraint.constant = trailing
        if animated {
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
        }
    }
}

extension CharacterListViewController: CharacterListDataSourceDelegate {
    var canLoadMore: Bool {
        return presenter.canLoadMore
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        hideFilterView(animated: true)
        searchBar.resignFirstResponder()
    }
    
    func loadMore() {
        presenter.handle(action: .loadMore)
    }
}

extension CharacterListViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
