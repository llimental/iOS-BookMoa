//
//  FavoriteViewController.swift
//  book-information-app
//
//  Created by 이상윤 on 2023/05/25.
//

import UIKit

final class FavoriteViewController: UIViewController {

    private var favoritesItems: [String] = []

    // MARK: - View LifeCycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let userDefaultsData = UserDefaults.standard.stringArray(forKey: MagicLiteral.favoritesTextForKey) {
            favoritesItems = userDefaultsData
        }
        loadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self

        configureHierarchy()
    }

    // MARK: - Private Functions

    private func loadData() {
        Task {
            var favoritesItemList: [CategoryController.CategoryBook] = []

            for item in favoritesItems {
                guard let networkResult = try await networkService.requestData(with: IndividualBookEndPoint(isbn: item)).item.first else { return }

                let bookImage = try await networkService.requestIndividualBookImage(with: networkResult)

                let favoritesItem = CategoryController.CategoryBook(title: networkResult.title, author: networkResult.author, cover: bookImage, isbn: networkResult.isbn13)

                favoritesItemList.append(favoritesItem)
            }
            applySnapshot(with: favoritesItemList)
        }
    }

    private func applySnapshot(with favoritesItemList: [CategoryController.CategoryBook]) {
        var snapshot = NSDiffableDataSourceSnapshot<CategoryController.Section, CategoryController.CategoryBook>()
        snapshot.appendSections([CategoryController.Section.categoryBookList])
        snapshot.appendItems(favoritesItemList, toSection: .categoryBookList)

        self.dataSource.apply(snapshot, animatingDifferences: false)
    }

    // MARK: - Private Properties

    private var snapshot = NSDiffableDataSourceSnapshot<CategoryController.Section, CategoryController.CategoryBook>()
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

extension FavoriteViewController {
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout{ (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            return self.createFavoritesLayout()
        }

        return layout
    }

    private func createFavoritesLayout() -> NSCollectionLayoutSection {
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

extension FavoriteViewController {
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
extension FavoriteViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CategoryBookCell {
            let bookDetailViewController = BookDetailViewController()

            bookDetailViewController.selectedItem = cell.bookISBN

            navigationController?.pushViewController(bookDetailViewController, animated: true)
        }
    }
}

extension FavoriteViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            let searchViewController = SearchViewController()

            searchViewController.queryString = searchText

            navigationController?.pushViewController(searchViewController, animated: true)
        }
    }
}
