//
//  HomeViewController.swift
//  book-information-app
//
//  Created by 이상윤 on 2023/05/17.
//

import UIKit

final class HomeViewController: UIViewController {
    static let titleElementKind: String = "title-element-kind"

    override func viewDidLoad() {
        super.viewDidLoad()

        configureHierarchy()
        configureDataSource()

        let networkService = NetworkService()
        networkService.receiveBestSellerData() { bestSellers in
            let bestSellerList = bestSellers.map { bestSeller in
                HomeController.Book(title: bestSeller.title, author: bestSeller.author)
            }
            self.applySnapshot(with: bestSellerList)
        }
    }

    func applySnapshot(with data: [HomeController.Book]) {
        DispatchQueue.main.async {
            self.snapshot.appendItems(data)
            self.dataSource.apply(self.snapshot)
        }
    }

    // MARK: - Private Properties

    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<HomeController.BestSeller, HomeController.Book>!
    private var snapshot: NSDiffableDataSourceSnapshot<HomeController.BestSeller, HomeController.Book>!
}

// MARK: - CollectionView Layout

extension HomeViewController {
    private func createLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0 / 2.5),
                                                   heightDimension: .fractionalHeight(1.0 / 2.5))
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

// MARK: - Configure Hierarchy & DataSource

extension HomeViewController {
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white

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
        }

        dataSource = UICollectionViewDiffableDataSource<HomeController.BestSeller, HomeController.Book>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, book: HomeController.Book) -> BestSellerCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: book)
        }

        let supplementaryViewRegistration = UICollectionView.SupplementaryRegistration<TitleSupplementaryView>(elementKind: HomeViewController.titleElementKind) { (supplementaryView, _, indexPath) in
            if let snapshot = self.snapshot {
                let bookSection = snapshot.sectionIdentifiers[indexPath.section]
                supplementaryView.titleLabel.text = bookSection.section
            }
        }

        dataSource.supplementaryViewProvider = { (_, _, index) in
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: supplementaryViewRegistration, for: index)
        }

        snapshot = NSDiffableDataSourceSnapshot<HomeController.BestSeller, HomeController.Book>()

        snapshot.appendSections([HomeController.BestSeller(section: "지금 인기있는 책들", books: nil)])
        snapshot.appendItems([])
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
