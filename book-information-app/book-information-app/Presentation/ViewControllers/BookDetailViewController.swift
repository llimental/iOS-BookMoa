//
//  BookDetailViewController.swift
//  book-information-app
//
//  Created by 이상윤 on 2023/05/27.
//

import UIKit

final class BookDetailViewController: UIViewController {

    // MARK: - Public Properties

    var selectedItem: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.backgroundColor = .white

        configure()
        loadData()
    }

    // MARK: - Private Properties

    private let networkService = NetworkService()

    private let scrollView = UIScrollView()
    private let entireInformationStack = UIStackView()

    private let bookTitleLabel = UILabel()
    private let bookAuthorLabel = UILabel()
    private let bookCoverImageView = UIImageView()
    private let bookPublishLabel = UILabel()
    private let previewButton = UIButton()

    private let firstDivider = UIView()
    private let secondDivider = UIView()
    private let thirdDivider = UIView()

    private let descriptionHeadLabel = UILabel()
    private let descriptionBodyLabel = UILabel()

    private let authorDescriptionHeadLabel = UILabel()
    private let authorDescriptionBodyLabel = UILabel()
}

// MARK: - Private Functions

extension BookDetailViewController {
    private func loadData() {
        Task {
            guard let selectedItemISBN = selectedItem else { return }

            guard let networkResult = try await networkService.requestData(with: IndividualBookEndPoint(isbn: selectedItemISBN)).item.first else { return }

            let bookImage = try await networkService.requestSingleImage(with: networkResult)

            configureData(with: networkResult, and: bookImage)
        }
    }

    private func configureData(with individualBook: IndividualBook.Item, and bookImage: UIImage) {
        bookTitleLabel.text = individualBook.title

        bookAuthorLabel.text = individualBook.author
        bookCoverImageView.image = bookImage
        bookPublishLabel.text = "\(individualBook.publisher) / \(individualBook.pubDate)\n\(individualBook.categoryName)"

        previewButton.setTitle("미리보기", for: .normal)

        descriptionHeadLabel.text = "줄거리"
        descriptionBodyLabel.text = individualBook.description

        authorDescriptionHeadLabel.text = "저자소개"
        authorDescriptionBodyLabel.text = "이건 저자소개임"
    }

    private func configure() {
        // MARK: - AutoLayout 해제

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        entireInformationStack.translatesAutoresizingMaskIntoConstraints = false

        bookTitleLabel.translatesAutoresizingMaskIntoConstraints = false

        bookAuthorLabel.translatesAutoresizingMaskIntoConstraints = false
        bookCoverImageView.translatesAutoresizingMaskIntoConstraints = false
        bookPublishLabel.translatesAutoresizingMaskIntoConstraints = false
        previewButton.translatesAutoresizingMaskIntoConstraints = false

        firstDivider.translatesAutoresizingMaskIntoConstraints = false
        secondDivider.translatesAutoresizingMaskIntoConstraints = false
        thirdDivider.translatesAutoresizingMaskIntoConstraints = false

        descriptionHeadLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionBodyLabel.translatesAutoresizingMaskIntoConstraints = false

        authorDescriptionHeadLabel.translatesAutoresizingMaskIntoConstraints = false
        authorDescriptionBodyLabel.translatesAutoresizingMaskIntoConstraints = false

        // MARK: - addSubview

        view.addSubview(scrollView)
        scrollView.addSubview(entireInformationStack)

        entireInformationStack.addSubview(bookTitleLabel)

        entireInformationStack.addSubview(bookAuthorLabel)
        entireInformationStack.addSubview(bookCoverImageView)
        entireInformationStack.addSubview(bookPublishLabel)

        entireInformationStack.addSubview(previewButton)

        entireInformationStack.addSubview(firstDivider)
        entireInformationStack.addSubview(secondDivider)
        entireInformationStack.addSubview(thirdDivider)

        entireInformationStack.addSubview(descriptionHeadLabel)
        entireInformationStack.addSubview(descriptionBodyLabel)

        entireInformationStack.addSubview(authorDescriptionHeadLabel)
        entireInformationStack.addSubview(authorDescriptionBodyLabel)

        // MARK: - Configure UI Components

        entireInformationStack.axis = .vertical
        entireInformationStack.alignment = .center

        bookTitleLabel.textAlignment = .center
        bookTitleLabel.font = UIFont.systemFont(ofSize: 28, weight: .medium)

        bookAuthorLabel.textAlignment = .center
        bookAuthorLabel.font = UIFont.systemFont(ofSize: 17)
        bookAuthorLabel.textColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00)

        bookPublishLabel.textAlignment = .center
        bookPublishLabel.font = UIFont.systemFont(ofSize: 14)
        bookPublishLabel.numberOfLines = 0
        bookPublishLabel.textColor = UIColor(red: 0.53, green: 0.56, blue: 0.59, alpha: 1.00)

        previewButton.setTitleColor(.white, for: .normal)
        previewButton.backgroundColor = UIColor(red: 0.38, green: 0.13, blue: 0.93, alpha: 1.00)
        previewButton.layer.cornerRadius = 15

        firstDivider.backgroundColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.00)
        secondDivider.backgroundColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.00)
        thirdDivider.backgroundColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.00)

        descriptionHeadLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)

        descriptionBodyLabel.font = UIFont.systemFont(ofSize: 12)
        descriptionBodyLabel.numberOfLines = 0
        descriptionBodyLabel.textAlignment = .left

        authorDescriptionHeadLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)

        authorDescriptionBodyLabel.font = UIFont.systemFont(ofSize: 12)
        authorDescriptionBodyLabel.numberOfLines = 0
        authorDescriptionBodyLabel.textAlignment = .left

        // MARK: - Custom Constraints

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

            entireInformationStack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            entireInformationStack.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            entireInformationStack.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            entireInformationStack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            entireInformationStack.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, multiplier: 1),
            entireInformationStack.heightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.heightAnchor, multiplier: 1.5),

            bookTitleLabel.topAnchor.constraint(equalTo: entireInformationStack.topAnchor),
            bookTitleLabel.leadingAnchor.constraint(equalTo: entireInformationStack.leadingAnchor),
            bookTitleLabel.trailingAnchor.constraint(equalTo: entireInformationStack.trailingAnchor),
            bookTitleLabel.heightAnchor.constraint(equalToConstant: 66),

            bookAuthorLabel.topAnchor.constraint(equalTo: bookTitleLabel.bottomAnchor, constant: 37),
            bookAuthorLabel.leadingAnchor.constraint(equalTo: entireInformationStack.leadingAnchor),
            bookAuthorLabel.trailingAnchor.constraint(equalTo: entireInformationStack.trailingAnchor),
            bookAuthorLabel.heightAnchor.constraint(equalToConstant: 21),

            bookCoverImageView.topAnchor.constraint(equalTo: bookAuthorLabel.bottomAnchor),
            bookCoverImageView.centerXAnchor.constraint(equalTo: entireInformationStack.centerXAnchor),
            bookCoverImageView.widthAnchor.constraint(equalToConstant: 160),
            bookCoverImageView.heightAnchor.constraint(equalToConstant: 220),

            bookPublishLabel.topAnchor.constraint(equalTo: bookCoverImageView.bottomAnchor),
            bookPublishLabel.leadingAnchor.constraint(equalTo: entireInformationStack.leadingAnchor),
            bookPublishLabel.trailingAnchor.constraint(equalTo: entireInformationStack.trailingAnchor),
            bookPublishLabel.heightAnchor.constraint(equalToConstant: 36),

            previewButton.topAnchor.constraint(equalTo: bookPublishLabel.bottomAnchor, constant: 20),
            previewButton.leadingAnchor.constraint(equalTo: entireInformationStack.leadingAnchor, constant: 20),
            previewButton.trailingAnchor.constraint(equalTo: entireInformationStack.trailingAnchor, constant: -20),
            previewButton.heightAnchor.constraint(equalToConstant: 50),

            firstDivider.topAnchor.constraint(equalTo: previewButton.bottomAnchor, constant: 24),
            firstDivider.leadingAnchor.constraint(equalTo: entireInformationStack.leadingAnchor, constant: 20),
            firstDivider.trailingAnchor.constraint(equalTo: entireInformationStack.trailingAnchor, constant: -20),
            firstDivider.heightAnchor.constraint(equalToConstant: 1),

            descriptionHeadLabel.topAnchor.constraint(equalTo: firstDivider.bottomAnchor, constant: 10),
            descriptionHeadLabel.leadingAnchor.constraint(equalTo: entireInformationStack.leadingAnchor, constant: 20),
            descriptionBodyLabel.trailingAnchor.constraint(equalTo: entireInformationStack.trailingAnchor, constant: -20),
            descriptionHeadLabel.heightAnchor.constraint(equalToConstant: 20),

            descriptionBodyLabel.topAnchor.constraint(equalTo: descriptionHeadLabel.bottomAnchor, constant: 10),
            descriptionBodyLabel.leadingAnchor.constraint(equalTo: entireInformationStack.leadingAnchor, constant: 20),
            descriptionBodyLabel.trailingAnchor.constraint(equalTo: entireInformationStack.trailingAnchor, constant: -20),

            secondDivider.topAnchor.constraint(equalTo: descriptionBodyLabel.bottomAnchor, constant: 10),
            secondDivider.leadingAnchor.constraint(equalTo: entireInformationStack.leadingAnchor, constant: 20),
            secondDivider.trailingAnchor.constraint(equalTo: entireInformationStack.trailingAnchor, constant: -20),
            secondDivider.heightAnchor.constraint(equalToConstant: 1),

            authorDescriptionHeadLabel.topAnchor.constraint(equalTo: secondDivider.bottomAnchor, constant: 10),
            authorDescriptionHeadLabel.leadingAnchor.constraint(equalTo: entireInformationStack.leadingAnchor, constant: 20),
            authorDescriptionHeadLabel.trailingAnchor.constraint(equalTo: entireInformationStack.trailingAnchor, constant: -20),
            authorDescriptionHeadLabel.heightAnchor.constraint(equalToConstant: 20),

            authorDescriptionBodyLabel.topAnchor.constraint(equalTo: authorDescriptionHeadLabel.bottomAnchor, constant: 10),
            authorDescriptionBodyLabel.leadingAnchor.constraint(equalTo: entireInformationStack.leadingAnchor, constant: 20),
            authorDescriptionBodyLabel.trailingAnchor.constraint(equalTo: entireInformationStack.trailingAnchor, constant: -20),

            thirdDivider.topAnchor.constraint(equalTo: authorDescriptionBodyLabel.bottomAnchor, constant: 10),
            thirdDivider.leadingAnchor.constraint(equalTo: entireInformationStack.leadingAnchor, constant: 20),
            thirdDivider.trailingAnchor.constraint(equalTo: entireInformationStack.trailingAnchor, constant: -20),
            thirdDivider.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}
