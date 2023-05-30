//
//  BookDetailViewController.swift
//  book-information-app
//
//  Created by 이상윤 on 2023/05/27.
//

import UIKit

final class BookDetailViewController: UIViewController {

    // MARK: - Public Properties

    var selectedItem: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        self.addKeyboardNotifications()
        view.backgroundColor = UIColor(red: 0.38, green: 0.13, blue: 0.93, alpha: 1.00)

        configure()
        loadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.removeKeyboardNotifications()
        UserDefaults.standard.set(memoTextView.text, forKey: selectedItem)
    }

    // MARK: - Private Properties

    private lazy var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))

    private let networkService = NetworkService()

    private let scrollView = UIScrollView()
    private let entireInformationView = UIView()
    private let backgroundView = UIView()
    private let backgroundImageView = UIImageView()

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
    private let moreDescriptionButton = UIButton()

    private let authorDescriptionHeadLabel = UILabel()
    private let authorDescriptionBodyLabel = UILabel()

    private let memoTextView = UITextView()
}

// MARK: - Private Functions

extension BookDetailViewController {
    private func loadData() {
        Task {
            guard let networkResult = try await networkService.requestData(with: IndividualBookEndPoint(isbn: selectedItem)).item.first else { return }

            let bookImage = try await networkService.requestSingleImage(with: networkResult)

            configureData(with: networkResult, and: bookImage)
        }
    }

    private func configureData(with individualBook: IndividualBook.Item, and bookImage: UIImage) {
        bookTitleLabel.text = individualBook.title

        bookAuthorLabel.text = individualBook.author
        bookCoverImageView.image = bookImage
        bookPublishLabel.text = "\(individualBook.publisher) / \(individualBook.pubDate)\n\(individualBook.categoryName)"
        descriptionBodyLabel.text = individualBook.description
        authorDescriptionBodyLabel.text = "이건 저자소개임"

        if UserDefaults.standard.string(forKey: selectedItem) != nil {
            memoTextView.text = UserDefaults.standard.string(forKey: selectedItem)
        }
    }

    private func configure() {
        // MARK: - AutoLayout 해제

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        entireInformationView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false

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
        moreDescriptionButton.translatesAutoresizingMaskIntoConstraints = false

        authorDescriptionHeadLabel.translatesAutoresizingMaskIntoConstraints = false
        authorDescriptionBodyLabel.translatesAutoresizingMaskIntoConstraints = false

        memoTextView.translatesAutoresizingMaskIntoConstraints = false

        // MARK: - addSubview

        view.addSubview(scrollView)
        view.addGestureRecognizer(tapGestureRecognizer)
        scrollView.addSubview(backgroundView)
        backgroundView.addSubview(backgroundImageView)
        scrollView.addSubview(entireInformationView)

        entireInformationView.addSubview(bookTitleLabel)

        entireInformationView.addSubview(bookAuthorLabel)
        entireInformationView.addSubview(bookCoverImageView)
        entireInformationView.addSubview(bookPublishLabel)

        entireInformationView.addSubview(previewButton)

        entireInformationView.addSubview(firstDivider)
        entireInformationView.addSubview(secondDivider)
        entireInformationView.addSubview(thirdDivider)

        entireInformationView.addSubview(descriptionHeadLabel)
        entireInformationView.addSubview(descriptionBodyLabel)

        entireInformationView.addSubview(authorDescriptionHeadLabel)
        entireInformationView.addSubview(authorDescriptionBodyLabel)
        entireInformationView.addSubview(moreDescriptionButton)

        entireInformationView.addSubview(memoTextView)

        // MARK: - Configure UI Components

        scrollView.showsVerticalScrollIndicator = false

        backgroundView.backgroundColor = .white

        backgroundImageView.image = UIImage(named: "EclipseIcon")
        backgroundImageView.contentMode = .scaleAspectFit

        bookTitleLabel.textAlignment = .center
        bookTitleLabel.font = UIFont.systemFont(ofSize: 28, weight: .medium)
        bookTitleLabel.numberOfLines = 0
        bookTitleLabel.textColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00)

        bookAuthorLabel.textAlignment = .center
        bookAuthorLabel.font = UIFont.systemFont(ofSize: 17)
        bookAuthorLabel.textColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 0.60)

        bookCoverImageView.contentMode = .scaleAspectFit

        bookPublishLabel.textAlignment = .center
        bookPublishLabel.font = UIFont.systemFont(ofSize: 14)
        bookPublishLabel.numberOfLines = 0
        bookPublishLabel.textColor = UIColor(red: 0.53, green: 0.56, blue: 0.59, alpha: 1.00)

        previewButton.setTitle(MagicLiteral.previewButtonTitle, for: .normal)
        previewButton.setTitleColor(.white, for: .normal)
        previewButton.backgroundColor = UIColor(red: 0.38, green: 0.13, blue: 0.93, alpha: 1.00)
        previewButton.layer.cornerRadius = 15

        firstDivider.backgroundColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.00)
        secondDivider.backgroundColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.00)
        thirdDivider.backgroundColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.00)

        descriptionHeadLabel.text = MagicLiteral.descriptionHeadLabelText
        descriptionHeadLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)

        descriptionBodyLabel.textAlignment = .left
        descriptionBodyLabel.font = UIFont.systemFont(ofSize: 12)
        descriptionBodyLabel.numberOfLines = 3

        moreDescriptionButton.setTitle(MagicLiteral.moreDescriptionButtonTitle, for: .normal)
        moreDescriptionButton.setTitleColor(UIColor(red: 0.38, green: 0.13, blue: 0.93, alpha: 1.00), for: .normal)
        moreDescriptionButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        moreDescriptionButton.addTarget(self, action: #selector(touchUpButton), for: .touchUpInside)

        authorDescriptionHeadLabel.text = MagicLiteral.authorDescriptionHeadLabelText
        authorDescriptionHeadLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)

        authorDescriptionBodyLabel.textAlignment = .left
        authorDescriptionBodyLabel.font = UIFont.systemFont(ofSize: 12)
        authorDescriptionBodyLabel.numberOfLines = 0

        memoTextView.text = MagicLiteral.memoViewPlaceholder
        memoTextView.font = UIFont.systemFont(ofSize: 12)
        memoTextView.textColor = UIColor(red: 0.29, green: 0.31, blue: 0.34, alpha: 1.00)
        memoTextView.backgroundColor = UIColor(red: 0.91, green: 0.91, blue: 0.99, alpha: 1.00)
        memoTextView.delegate = self

        // MARK: - Custom Constraints

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

            backgroundView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            backgroundView.heightAnchor.constraint(equalTo: entireInformationView.heightAnchor, multiplier: 0.7),

            backgroundImageView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: -157),
            backgroundImageView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 70),
            backgroundImageView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -70),

            entireInformationView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            entireInformationView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            entireInformationView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            entireInformationView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            entireInformationView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),

            bookTitleLabel.topAnchor.constraint(equalTo: entireInformationView.topAnchor),
            bookTitleLabel.leadingAnchor.constraint(equalTo: entireInformationView.leadingAnchor),
            bookTitleLabel.trailingAnchor.constraint(equalTo: entireInformationView.trailingAnchor),
            bookTitleLabel.heightAnchor.constraint(equalToConstant: 120),

            bookAuthorLabel.topAnchor.constraint(equalTo: bookTitleLabel.bottomAnchor),
            bookAuthorLabel.leadingAnchor.constraint(equalTo: entireInformationView.leadingAnchor),
            bookAuthorLabel.trailingAnchor.constraint(equalTo: entireInformationView.trailingAnchor),
            bookAuthorLabel.heightAnchor.constraint(equalToConstant: 21),

            bookCoverImageView.topAnchor.constraint(equalTo: bookAuthorLabel.bottomAnchor, constant: 4),
            bookCoverImageView.centerXAnchor.constraint(equalTo: entireInformationView.centerXAnchor),
            bookCoverImageView.widthAnchor.constraint(equalToConstant: 160),
            bookCoverImageView.heightAnchor.constraint(equalToConstant: 220),

            bookPublishLabel.topAnchor.constraint(equalTo: bookCoverImageView.bottomAnchor, constant: 4),
            bookPublishLabel.leadingAnchor.constraint(equalTo: entireInformationView.leadingAnchor),
            bookPublishLabel.trailingAnchor.constraint(equalTo: entireInformationView.trailingAnchor),
            bookPublishLabel.heightAnchor.constraint(equalToConstant: 36),

            previewButton.topAnchor.constraint(equalTo: bookPublishLabel.bottomAnchor, constant: 20),
            previewButton.leadingAnchor.constraint(equalTo: entireInformationView.leadingAnchor, constant: 20),
            previewButton.trailingAnchor.constraint(equalTo: entireInformationView.trailingAnchor, constant: -20),
            previewButton.heightAnchor.constraint(equalToConstant: 50),

            firstDivider.topAnchor.constraint(equalTo: previewButton.bottomAnchor, constant: 24),
            firstDivider.leadingAnchor.constraint(equalTo: entireInformationView.leadingAnchor, constant: 20),
            firstDivider.trailingAnchor.constraint(equalTo: entireInformationView.trailingAnchor, constant: -20),
            firstDivider.heightAnchor.constraint(equalToConstant: 1),

            descriptionHeadLabel.topAnchor.constraint(equalTo: firstDivider.bottomAnchor, constant: 10),
            descriptionHeadLabel.leadingAnchor.constraint(equalTo: entireInformationView.leadingAnchor, constant: 20),
            descriptionBodyLabel.trailingAnchor.constraint(equalTo: entireInformationView.trailingAnchor, constant: -20),
            descriptionHeadLabel.heightAnchor.constraint(equalToConstant: 20),

            descriptionBodyLabel.topAnchor.constraint(equalTo: descriptionHeadLabel.bottomAnchor, constant: 10),
            descriptionBodyLabel.leadingAnchor.constraint(equalTo: entireInformationView.leadingAnchor, constant: 20),
            descriptionBodyLabel.trailingAnchor.constraint(equalTo: entireInformationView.trailingAnchor, constant: -20),

            moreDescriptionButton.topAnchor.constraint(equalTo: descriptionBodyLabel.bottomAnchor),
            moreDescriptionButton.leadingAnchor.constraint(equalTo: entireInformationView.leadingAnchor, constant: 20),
            moreDescriptionButton.heightAnchor.constraint(equalToConstant: 15),

            secondDivider.topAnchor.constraint(equalTo: moreDescriptionButton.bottomAnchor, constant: 10),
            secondDivider.leadingAnchor.constraint(equalTo: entireInformationView.leadingAnchor, constant: 20),
            secondDivider.trailingAnchor.constraint(equalTo: entireInformationView.trailingAnchor, constant: -20),
            secondDivider.heightAnchor.constraint(equalToConstant: 1),

            authorDescriptionHeadLabel.topAnchor.constraint(equalTo: secondDivider.bottomAnchor, constant: 10),
            authorDescriptionHeadLabel.leadingAnchor.constraint(equalTo: entireInformationView.leadingAnchor, constant: 20),
            authorDescriptionHeadLabel.trailingAnchor.constraint(equalTo: entireInformationView.trailingAnchor, constant: -20),
            authorDescriptionHeadLabel.heightAnchor.constraint(equalToConstant: 20),

            authorDescriptionBodyLabel.topAnchor.constraint(equalTo: authorDescriptionHeadLabel.bottomAnchor, constant: 10),
            authorDescriptionBodyLabel.leadingAnchor.constraint(equalTo: entireInformationView.leadingAnchor, constant: 20),
            authorDescriptionBodyLabel.trailingAnchor.constraint(equalTo: entireInformationView.trailingAnchor, constant: -20),

            thirdDivider.topAnchor.constraint(equalTo: authorDescriptionBodyLabel.bottomAnchor, constant: 10),
            thirdDivider.leadingAnchor.constraint(equalTo: entireInformationView.leadingAnchor, constant: 20),
            thirdDivider.trailingAnchor.constraint(equalTo: entireInformationView.trailingAnchor, constant: -20),
            thirdDivider.heightAnchor.constraint(equalToConstant: 1),

            memoTextView.topAnchor.constraint(equalTo: thirdDivider.bottomAnchor, constant: 10),
            memoTextView.leadingAnchor.constraint(equalTo: entireInformationView.leadingAnchor, constant: 20),
            memoTextView.trailingAnchor.constraint(equalTo: entireInformationView.trailingAnchor, constant: -20),
            memoTextView.bottomAnchor.constraint(equalTo: entireInformationView.bottomAnchor, constant: -37),
            memoTextView.heightAnchor.constraint(equalToConstant: 116)
        ])
    }

    private func addKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(_ notification: NSNotification) {
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
        let tabBarHeight: CGFloat = self.tabBarController?.tabBar.frame.size.height else {
            return
        }
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        self.view.frame.origin.y -= keyboardHeight - tabBarHeight
    }

    @objc private func keyboardWillHide(_ notification: NSNotification) {
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
        let tabBarHeight: CGFloat = self.tabBarController?.tabBar.frame.size.height else {
            return
        }
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        self.view.frame.origin.y += keyboardHeight - tabBarHeight
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc private func touchUpButton() {
        descriptionBodyLabel.numberOfLines = 0
        moreDescriptionButton.isHidden = true
    }
}

extension BookDetailViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == MagicLiteral.memoViewPlaceholder {
            textView.text = nil
            textView.textColor = .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = MagicLiteral.memoViewPlaceholder
            textView.textColor = UIColor(red: 0.29, green: 0.31, blue: 0.34, alpha: 1.00)
        }
    }
}
