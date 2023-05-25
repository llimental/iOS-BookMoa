//
//  HomeViewController.swift
//  book-information-app
//
//  Created by 이상윤 on 2023/05/17.
//

import UIKit

final class HomeViewController: UIViewController {
    static let titleElementKind: String = MagicLiteral.titleElementKind

    override func viewDidLoad() {
        super.viewDidLoad()

        configureGradientLayer()
        configureHierarchy()
        configureDataSource()
        configureRefreshControl()
        setCategory()
        loadData()
    }

    // MARK: - Private Functions

    private func setCategory() {
        let sortedCategory = Category.categoryList.sorted { $0.key < $1.key }

        for (_, categoryId) in sortedCategory {
            let category = HomeController.Category(title: categoryId)
            categoryList.append(category)
        }
    }

    private func loadData() {
        Task {
            let networkResults = try await networkService.requestData(with: BestSellerEndPoint()).item

            let bookImages = try await networkService.requestImage(with: networkResults)

            var bookList: [HomeController.Book] = []

            for (networkResult, bookImage) in zip(networkResults, bookImages) {
                let book = HomeController.Book(title: networkResult.title, author: networkResult.author, cover: bookImage)
                bookList.append(book)
            }
            applySnapshot(with: bookList)
        }
    }

    private func applySnapshot(with bookList: [HomeController.Book]) {
        var snapshot = NSDiffableDataSourceSnapshot<HomeController.Section, HomeController.Book>()
        snapshot.appendSections([HomeController.Section.bestSeller])
        snapshot.appendItems(bookList)
        self.dataSource.apply(snapshot, animatingDifferences: true)
    }

    private func configureGradientLayer() {
        gradientLayer.frame = view.frame
        gradientLayer.colors = [UIColor(red: 0.38, green: 0.13, blue: 0.93, alpha: 1.00).cgColor, UIColor.white.cgColor]
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.type = .axial

        view.layer.addSublayer(gradientLayer)
    }

    // MARK: - Private Properties

    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<HomeController.Section, HomeController.Book>!
    private var snapshot: NSDiffableDataSourceSnapshot<HomeController.Section, HomeController.Book>!
    private var gradientLayer = CAGradientLayer()
    private var categoryList: [HomeController.Category] = []
    private let networkService = NetworkService()
}

// MARK: - CollectionView Layout

extension HomeViewController {
    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0 / 2.5),
                                                   heightDimension: .fractionalHeight(0.8 / 2.5))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .groupPaging
            section.interGroupSpacing = 20
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)

            let titleSupplementarySize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                heightDimension: .estimated(44))
            let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: titleSupplementarySize,
                                                                                 elementKind: HomeViewController.titleElementKind,
                                                                                 alignment: .top)

            section.boundarySupplementaryItems = [titleSupplementary]

            return section
        }

        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = 20

        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider, configuration: configuration)

        return layout
    }
}

// MARK: - Configure CollectionView (Hierarchy & DataSource & RefreshControl)

extension HomeViewController {
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear

        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<BestSellerCell, HomeController.Book> { (cell, _, book) in
            cell.booktitleLabel.text = book.title
            cell.bookAuthorLabel.text = book.author
            cell.bookImageView.image = book.cover
        }

        dataSource = UICollectionViewDiffableDataSource<HomeController.Section, HomeController.Book>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, book: HomeController.Book) -> BestSellerCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: book)
        }

        let supplementaryViewRegistration = UICollectionView.SupplementaryRegistration<TitleSupplementaryView>(elementKind: HomeViewController.titleElementKind) { (supplementaryView, _, indexPath) in
            if let snapshot = self.snapshot {
                let bookSection = snapshot.sectionIdentifiers[indexPath.section]
                supplementaryView.titleLabel.text = bookSection.rawValue
            }
        }

        dataSource.supplementaryViewProvider = { (_, _, index) in
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: supplementaryViewRegistration, for: index)
        }

        snapshot = NSDiffableDataSourceSnapshot<HomeController.Section, HomeController.Book>()

        snapshot.appendSections([HomeController.Section.bestSeller, HomeController.Section.category])
        snapshot.appendItems([])
        dataSource.apply(snapshot)
    }

    private func configureRefreshControl() {
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.attributedTitle = NSAttributedString(string: MagicLiteral.refreshControlTitle)
        collectionView.refreshControl?.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }

    @objc private func handleRefreshControl() {
        loadData()

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
}
