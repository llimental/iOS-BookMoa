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

        view.backgroundColor = .white
        
        configureBackgroundTopView()
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
        var snapshot = NSDiffableDataSourceSnapshot<HomeController.Section, AnyHashable>()
        snapshot.appendSections([HomeController.Section.bestSeller, HomeController.Section.category])
        snapshot.appendItems(bookList, toSection: .bestSeller)
        snapshot.appendItems(categoryList, toSection: .category)

        self.dataSource.apply(snapshot, animatingDifferences: true)
    }

    private func configureBackgroundTopView() {
        let backgroundTopView = UIView()

        view.addSubview(backgroundTopView)

        backgroundTopView.backgroundColor = UIColor(red: 0.38, green: 0.13, blue: 0.93, alpha: 1.00)
        backgroundTopView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            backgroundTopView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundTopView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundTopView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundTopView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }

    // MARK: - Private Properties

    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<HomeController.Section, AnyHashable>!
    private var snapshot: NSDiffableDataSourceSnapshot<HomeController.Section, AnyHashable>!
    private var categoryList: [HomeController.Category] = []
    private let networkService = NetworkService()
}

// MARK: - CollectionView Layout

extension HomeViewController {
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout{ (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in

            let sectionLayoutKind = HomeController.Section.allCases[sectionIndex]
            switch sectionLayoutKind {
            case .bestSeller: return self.createBestSellerLayout()
            case .category: return self.createCategoryLayout()
            }
        }

        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = 20
        layout.configuration = configuration

        return layout
    }

    private func createBestSellerLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(128),
                                               heightDimension: .absolute(206))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let titleSupplementarySize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                            heightDimension: .estimated(44))
        let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: titleSupplementarySize,
                                                                             elementKind: HomeViewController.titleElementKind,
                                                                             alignment: .top)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        section.boundarySupplementaryItems = [titleSupplementary]
        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12)

        return section
    }

    private func createCategoryLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(60))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(9.5)
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12)

        let titleSupplementarySize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                            heightDimension: .estimated(44))
        let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: titleSupplementarySize,
                                                                             elementKind: HomeViewController.titleElementKind,
                                                                             alignment: .top)

        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [titleSupplementary]
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12)

        return section
    }
}

// MARK: - Configure CollectionView (Hierarchy & DataSource & RefreshControl)

extension HomeViewController {
    private func configureHierarchy() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())

        view.addSubview(collectionView)

        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.layer.cornerRadius = 15
        collectionView.register(BestSellerCell.self, forCellWithReuseIdentifier: BestSellerCell.reuseIdentifier)
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.reuseIdentifier)
        collectionView.register(TitleSupplementaryView.self, forSupplementaryViewOfKind: HomeViewController.titleElementKind, withReuseIdentifier: TitleSupplementaryView.reuseIdentifier)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 135),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }

    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) {
            (collectionView, indexPath, item) -> UICollectionViewCell? in

            let sectionType = HomeController.Section.allCases[indexPath.section]
            switch sectionType {
            case .bestSeller:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BestSellerCell.reuseIdentifier, for: indexPath) as? BestSellerCell else {
                    return UICollectionViewCell()
                }

                if let bookItem = item as? HomeController.Book {
                    cell.booktitleLabel.text = bookItem.title
                    cell.bookAuthorLabel.text = bookItem.author
                    cell.bookImageView.image = bookItem.cover
                }

                return cell
            case .category:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseIdentifier, for: indexPath) as? CategoryCell else {
                    return UICollectionViewCell()
                }

                if let categoryItem = item as? HomeController.Category {
                    cell.categoryLabel.text = categoryItem.title
                }

                return cell
            }
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

            supplementaryView.titleLabel.text = HomeController.Section.allCases[indexPath.section].rawValue

            switch indexPath.section {
            case 0:
                supplementaryView.titleDecorateImageView.image = UIImage(named: "StarIcon")
                supplementaryView.disclosureImageView.image = UIImage(systemName: "chevron.right")
                supplementaryView.disclosureImageView.tintColor = .black
            default:
                supplementaryView.titleDecorateImageView.image = UIImage(named: "SearchRefractionIcon")
            }

            return supplementaryView
        }

        snapshot = NSDiffableDataSourceSnapshot<HomeController.Section, AnyHashable>()
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

// MARK: - CollectionView Delegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CategoryCell {
            cell.backgroundColor = UIColor(red: 0.38, green: 0.13, blue: 0.93, alpha: 1.00)
            cell.categoryLabel.textColor = .white
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CategoryCell {
            cell.backgroundColor = UIColor(red: 0.87, green: 0.89, blue: 0.90, alpha: 1.00)
            cell.categoryLabel.textColor = .black
        }
    }
}
