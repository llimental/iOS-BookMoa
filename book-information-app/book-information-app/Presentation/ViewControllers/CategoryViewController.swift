//
//  CategoryViewController.swift
//  book-information-app
//
//  Created by 이상윤 on 2023/05/30.
//

import UIKit

final class CategoryViewController: UIViewController {

    var categoryID: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationItem.title = categoryID
        navigationItem.searchController = searchController

        configureHierarchy()
        configureDataSource()
        loadData()
    }

    // MARK: - Private Functions

    private func loadData() {
        Task {
            let networkResults = try await networkService.requestData(with: BestSellerEndPoint()).item

            let bookImages = try await networkService.requestMultipleImage(with: networkResults)

            var bookList: [HomeController.Book] = []

            for (networkResult, bookImage) in zip(networkResults, bookImages) {
                let book = HomeController.Book(title: networkResult.title, author: networkResult.author, cover: bookImage, isbn: networkResult.isbn13)
                bookList.append(book)
            }
            applySnapshot(with: bookList)
        }
    }

    private func applySnapshot(with bookList: [HomeController.Book]) {
        var snapshot = NSDiffableDataSourceSnapshot<HomeController.Section, AnyHashable>()
        snapshot.appendSections([HomeController.Section.bestSeller])
        snapshot.appendItems(bookList, toSection: .bestSeller)

        self.dataSource.apply(snapshot, animatingDifferences: true)
    }

    // MARK: - Private Properties

    private var dataSource: UICollectionViewDiffableDataSource<HomeController.Section, AnyHashable>!
    private var snapshot = NSDiffableDataSourceSnapshot<HomeController.Section, AnyHashable>()
    private let networkService = NetworkService()
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
        searchController.searchBar.placeholder = ""
        searchController.searchBar.searchTextField.backgroundColor = .white
        searchController.searchBar.setImage(UIImage(named: "SearchBarIcon"), for: .search, state: .normal)

        searchController.obscuresBackgroundDuringPresentation = true

        return searchController
    }()
}

// MARK: - CollectionView Layout

extension CategoryViewController {
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout{ (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            return self.createBestSellerLayout()
        }

        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = 20
        layout.configuration = configuration

        return layout
    }

    private func createBestSellerLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(180))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(17)

        let titleSupplementarySize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                            heightDimension: .estimated(44))
        let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: titleSupplementarySize,
                                                                             elementKind: UICollectionView.elementKindSectionHeader,
                                                                             alignment: .top)

        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [titleSupplementary]
        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)

        return section
    }
}

// MARK: - Configure CollectionView (Hierarchy & DataSource & RefreshControl)

extension CategoryViewController {
    private func configureHierarchy() {
        view.addSubview(collectionView)

        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        collectionView.register(BestSellerCell.self, forCellWithReuseIdentifier: BestSellerCell.reuseIdentifier)
        collectionView.register(TitleSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleSupplementaryView.reuseIdentifier)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }

    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) {
            (collectionView, indexPath, item) -> UICollectionViewCell? in

            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BestSellerCell.reuseIdentifier, for: indexPath) as? BestSellerCell else {
                return UICollectionViewCell()
            }

            if let bookItem = item as? HomeController.Book {
                cell.booktitleLabel.text = bookItem.title
                cell.bookAuthorLabel.text = bookItem.author
                cell.bookImageView.image = bookItem.cover
                cell.bookISBN = bookItem.isbn
            }

            return cell
        }

        dataSource.supplementaryViewProvider = { (
            collectionView: UICollectionView,
            kind: String,
            indexPath: IndexPath) -> UICollectionReusableView? in

            guard let supplementaryView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                                          withReuseIdentifier: TitleSupplementaryView.reuseIdentifier,
                                                                                          for: indexPath) as? TitleSupplementaryView else {
                return UICollectionReusableView()
            }

            supplementaryView.titleLabel.text = HomeController.Section.bestSeller.rawValue
            supplementaryView.titleDecorateImageView.image = UIImage(named: "StarIcon")
            supplementaryView.disclosureImageView.tintColor = .black

            return supplementaryView
        }

        snapshot.appendSections([HomeController.Section.bestSeller])
        snapshot.appendItems([])
        dataSource.apply(snapshot)
    }
}

// MARK: - CollectionView Delegate
extension CategoryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? BestSellerCell {
            let bookDetailViewController = BookDetailViewController()

            bookDetailViewController.selectedItem = cell.bookISBN

            navigationController?.pushViewController(bookDetailViewController, animated: true)
        }
    }
}
