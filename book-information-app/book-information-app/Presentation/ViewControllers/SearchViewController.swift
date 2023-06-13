//
//  SearchViewController.swift
//  book-information-app
//
//  Created by 이상윤 on 2023/06/01.
//

import UIKit

final class SearchViewController: UIViewController {

    var queryString: String = ConstantsString.kBlank
    private var startIndex: Int = ConstantsNumber.kOne
    private var totalResult: Int = ConstantsNumber.kZero
    private var itemsPerPage: Int = ConstantsNumber.kZero

    // MARK: - View LifeCycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        applySnapshot()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        configureHierarchy()
        loadData()
    }

    // MARK: - Private Functions

    private func loadData() {
        Task {
            let networkResults = try await networkService.requestData(with: SearchEndPoint(queryString: queryString, startIndex: String(startIndex)))

            let bookImages = try await networkService.requestSearchResultImage(with: networkResults.item)

            navigationItem.title = MagicLiteral.searchViewControllerTitle + networkResults.query
            totalResult = networkResults.totalResults
            itemsPerPage = networkResults.itemsPerPage

            for (networkResult, bookImage) in zip(networkResults.item, bookImages) {
                let book = CategoryController.CategoryBook(title: networkResult.title, author: networkResult.author, cover: bookImage, isbn: networkResult.isbn13)
                searchBookList.append(book)
            }
            applySnapshot()
        }
    }

    private func loadMoreData() {
        Task {
            let networkResults = try await networkService.requestData(with: SearchEndPoint(queryString: queryString, startIndex: String(startIndex)))

            let bookImages = try await networkService.requestSearchResultImage(with: networkResults.item)

            var currentSearchBookList = dataSource.snapshot().itemIdentifiers

            for (networkResult, bookImage) in zip(networkResults.item, bookImages) {
                let book = CategoryController.CategoryBook(title: networkResult.title, author: networkResult.author, cover: bookImage, isbn: networkResult.isbn13)
                currentSearchBookList.append(book)
            }
            searchBookList = currentSearchBookList
            applySnapshot()
        }
    }

    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<CategoryController.Section, CategoryController.CategoryBook>()
        snapshot.appendSections([CategoryController.Section.categoryBookList])
        snapshot.appendItems(searchBookList, toSection: .categoryBookList)

        self.dataSource.apply(snapshot, animatingDifferences: false)
    }

    // MARK: - Private Properties

    private var snapshot = NSDiffableDataSourceSnapshot<CategoryController.Section, CategoryController.CategoryBook>()
    private var searchBookList: [CategoryController.CategoryBook] = []
    private let networkService = NetworkService()
    private lazy var dataSource = configureDataSource()
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())

        collectionView.backgroundColor = .white
        collectionView.layer.cornerRadius = 15
        collectionView.showsVerticalScrollIndicator = false

        return collectionView
    }()
    private var searchController: UISearchController = {
        let searchController = UISearchController()

        searchController.searchBar.layer.cornerRadius = 20
        searchController.searchBar.placeholder = ConstantsString.kBlank
        searchController.searchBar.searchTextField.backgroundColor = .white
        searchController.searchBar.setImage(UIImage(named: ConstantsSearchController.kImageName), for: .search, state: .normal)

        searchController.obscuresBackgroundDuringPresentation = true

        return searchController
    }()
}

// MARK: - CollectionView Layout

extension SearchViewController {
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout{ (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            return self.createCategoryLayout()
        }

        return layout
    }

    private func createCategoryLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(180))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(17)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)

        return section
    }
}

// MARK: - Configure CollectionView (Hierarchy & DataSource & RefreshControl)

extension SearchViewController {
    private func configureHierarchy() {
        view.addSubview(collectionView)

        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        collectionView.register(CategoryBookCell.self, forCellWithReuseIdentifier: CategoryBookCell.reuseIdentifier)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }

    private func configureDataSource() -> UICollectionViewDiffableDataSource<CategoryController.Section, CategoryController.CategoryBook> {
        let dataSource = UICollectionViewDiffableDataSource<CategoryController.Section, CategoryController.CategoryBook>(collectionView: collectionView) {
            (collectionView, indexPath, item) -> UICollectionViewCell? in

            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryBookCell.reuseIdentifier, for: indexPath) as? CategoryBookCell else {
                return UICollectionViewCell()
            }

            cell.configure(with: item)

            return cell
        }

        return dataSource
    }
}

// MARK: - CollectionView Delegate

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CategoryBookCell {
            let bookDetailViewController = BookDetailViewController()

            bookDetailViewController.selectedItem = cell.bookISBN

            navigationController?.pushViewController(bookDetailViewController, animated: true)
        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard indexPath.item == collectionView.numberOfItems(inSection: indexPath.section) - ConstantsNumber.kOne, startIndex * itemsPerPage < totalResult else {
            return
        }
        startIndex += ConstantsNumber.kOne
        loadMoreData()
    }
}
