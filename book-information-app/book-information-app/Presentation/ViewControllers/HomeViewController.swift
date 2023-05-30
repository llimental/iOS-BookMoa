//
//  HomeViewController.swift
//  book-information-app
//
//  Created by 이상윤 on 2023/05/17.
//

import UIKit

final class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        navigationItem.searchController = searchController

        configureHierarchy()
        configureRefreshControl()
        setCategory()
        loadData()
    }

    // MARK: - Private Functions

    private func setCategory() {
        let sortedCategory = CategoryID.categoryIDList.sorted { $0.key < $1.key }

        for (_, categoryName) in sortedCategory {
            let category = HomeController.Category(title: categoryName)
            categoryList.append(category)
        }
    }

    private func loadData() {
        activityIndicator.startAnimating()

        Task {
            let networkResults = try await networkService.requestData(with: BestSellerEndPoint()).item

            let bookImages = try await networkService.requestBestSellerImage(with: networkResults)

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
        snapshot.appendSections([HomeController.Section.bestSeller, HomeController.Section.category])
        snapshot.appendItems(bookList, toSection: .bestSeller)
        snapshot.appendItems(categoryList, toSection: .category)
        
        activityIndicator.stopAnimating()

        self.dataSource.apply(snapshot, animatingDifferences: true)
    }

    // MARK: - Private Properties

    private lazy var dataSource = configureDataSource()
    private var categoryList: [HomeController.Category] = []
    private let networkService = NetworkService()
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())

        collectionView.backgroundColor = .white
        collectionView.layer.cornerRadius = 15
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false

        return collectionView
    }()
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()

        activityIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        activityIndicator.center = self.view.center
        activityIndicator.color = UIColor(red: 0.38, green: 0.13, blue: 0.93, alpha: 1.00)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .medium

        activityIndicator.stopAnimating()

        return activityIndicator
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
                                               heightDimension: .estimated(215))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let titleSupplementarySize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                            heightDimension: .estimated(44))
        let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: titleSupplementarySize,
                                                                             elementKind: UICollectionView.elementKindSectionHeader,
                                                                             alignment: .top)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        section.boundarySupplementaryItems = [titleSupplementary]
        section.interGroupSpacing = 16
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)

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

        let titleSupplementarySize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                            heightDimension: .estimated(44))
        let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: titleSupplementarySize,
                                                                             elementKind: UICollectionView.elementKindSectionHeader,
                                                                             alignment: .top)

        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [titleSupplementary]
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)

        return section
    }
}

// MARK: - Configure CollectionView (Hierarchy & DataSource & RefreshControl)

extension HomeViewController {
    private func configureHierarchy() {
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)

        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        collectionView.register(BestSellerCell.self, forCellWithReuseIdentifier: BestSellerCell.reuseIdentifier)
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.reuseIdentifier)
        collectionView.register(TitleSupplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TitleSupplementaryView.reuseIdentifier)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
    }

    private func configureDataSource() -> UICollectionViewDiffableDataSource<HomeController.Section, AnyHashable> {
        let dataSource = UICollectionViewDiffableDataSource<HomeController.Section, AnyHashable>(collectionView: collectionView) {
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
                    cell.bookISBN = bookItem.isbn
                }

                return cell
            case .category:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseIdentifier, for: indexPath) as? CategoryCell else {
                    return UICollectionViewCell()
                }

                guard let categoryItem = item as? HomeController.Category,
                      let categoryID = CategoryID.categoryIDList.first(where: { $0.value == categoryItem.title })?.key else {
                    return UICollectionViewCell()
                }
                cell.categoryLabel.text = categoryItem.title
                cell.categoryID = String(categoryID)

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
                supplementaryView.disclosureImageView.tintColor = .black
            default:
                supplementaryView.titleDecorateImageView.image = UIImage(named: "SearchRefractionIcon")
                supplementaryView.disclosureImageView.tintColor = .white
            }

            return supplementaryView
        }

        return dataSource
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
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CategoryCell {
            cell.applyGradientBackground()
            cell.categoryLabel.textColor = .white

            let categoryViewController = CategoryViewController()

            categoryViewController.categoryID = cell.categoryID

            navigationController?.pushViewController(categoryViewController, animated: true)

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                cell.removeGradientBackground()
                cell.categoryLabel.textColor = .black
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? BestSellerCell {
            let bookDetailViewController = BookDetailViewController()

            bookDetailViewController.selectedItem = cell.bookISBN

            navigationController?.pushViewController(bookDetailViewController, animated: true)
        }
    }
}
