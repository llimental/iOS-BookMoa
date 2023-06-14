//
//  BookDetailViewController.swift
//  book-information-app
//
//  Created by 이상윤 on 2023/05/27.
//

import UIKit

final class BookDetailViewController: UIViewController {

    // MARK: - Public Properties

    var selectedItem: String = ConstantsString.kBlank

    // MARK: - View LifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let favoritesItems = UserDefaults.standard.stringArray(forKey: ConstantsFavorites.favoritesTextForKey) ?? []
        favoritesButton.tintColor = favoritesItems.contains(selectedItem) ? ConstantsFavorites.kColor : .white
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.addKeyboardNotifications()
        view.backgroundColor = ConstantsColor.kMainColor

        favoritesButton.addTarget(self, action: #selector(favoritesButtonTouched), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: favoritesButton)

        configure()
        loadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.removeKeyboardNotifications()
        UserDefaults.standard.set(memoTextView.text, forKey: selectedItem)
    }

    // MARK: - Private Properties

    private var imageLinks: [String] = []
    private lazy var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    private lazy var descriptionTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(controlDescription))
    private lazy var authorTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(controlAuthorDescription))
    private lazy var favoritesButton: UIButton = {
        let favoriteButton = UIButton()

        favoriteButton.setImage(UIImage(systemName: ConstantsFavorites.kButtonImageName), for: .normal)

        return favoriteButton
    }()

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
    private let descriptionBodyLabel = DynamicLabel()

    private let authorDescriptionHeadLabel = UILabel()
    private let authorDescriptionBodyLabel = DynamicLabel()

    private let memoTextView = UITextView()

    private let collaboratorLabel = UILabel()
}

// MARK: - Private Functions

extension BookDetailViewController {
    private func loadData() {
        Task {
            guard let networkResult = try await networkService.requestData(with: IndividualBookEndPoint(isbn: selectedItem)).item.first else { return }

            let bookImage = try await networkService.requestIndividualBookImage(with: networkResult)

            configureData(with: networkResult, and: bookImage)
        }
    }

    private func configureData(with individualBook: IndividualBook.Item, and bookImage: UIImage) {
        bookTitleLabel.text = individualBook.title

        bookAuthorLabel.text = individualBook.author
        bookCoverImageView.image = bookImage
        bookPublishLabel.text = "\(individualBook.publisher) / \(individualBook.pubDate)\n\(individualBook.categoryName)"

        descriptionBodyLabel.fullText = individualBook.fullDescription.components(separatedBy: ["<", "B", "R", ">", "b", "/", "r"]).joined()
        checkLabelSafety(with: descriptionBodyLabel)

        authorDescriptionBodyLabel.fullText = individualBook.subInfo.authors.first?.authorInfo
        checkLabelSafety(with: authorDescriptionBodyLabel)

        if UserDefaults.standard.string(forKey: selectedItem) != nil {
            memoTextView.text = UserDefaults.standard.string(forKey: selectedItem)
        }

        imageLinks = individualBook.subInfo.previewImgList
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

        authorDescriptionHeadLabel.translatesAutoresizingMaskIntoConstraints = false
        authorDescriptionBodyLabel.translatesAutoresizingMaskIntoConstraints = false

        memoTextView.translatesAutoresizingMaskIntoConstraints = false

        collaboratorLabel.translatesAutoresizingMaskIntoConstraints = false

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
        descriptionBodyLabel.addGestureRecognizer(descriptionTapGestureRecognizer)

        entireInformationView.addSubview(authorDescriptionHeadLabel)
        entireInformationView.addSubview(authorDescriptionBodyLabel)
        authorDescriptionBodyLabel.addGestureRecognizer(authorTapGestureRecognizer)

        entireInformationView.addSubview(memoTextView)

        entireInformationView.addSubview(collaboratorLabel)

        // MARK: - Configure UI Components

        scrollView.showsVerticalScrollIndicator = false

        backgroundView.backgroundColor = .white

        backgroundImageView.image = UIImage(named: ConstantsString.kDetailViewBackgroundImageName)
        backgroundImageView.contentMode = .scaleAspectFit

        bookTitleLabel.textAlignment = .center
        bookTitleLabel.font = UIFont.preferredFont(forTextStyle: .title1)
        bookTitleLabel.numberOfLines = ConstantsNumber.kZero
        bookTitleLabel.textColor = ConstantsBookDetailColor.kTitle

        bookAuthorLabel.textAlignment = .center
        bookAuthorLabel.font = UIFont.preferredFont(forTextStyle: .callout)
        bookAuthorLabel.textColor = ConstantsBookDetailColor.kAuthor

        bookCoverImageView.contentMode = .scaleAspectFit

        bookPublishLabel.textAlignment = .center
        bookPublishLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        bookPublishLabel.numberOfLines = ConstantsNumber.kZero
        bookPublishLabel.textColor = ConstantsBookDetailColor.kPublish

        previewButton.setTitle(ConstantsBookDetailText.kPreviewButtonTitle, for: .normal)
        previewButton.setTitleColor(.white, for: .normal)
        previewButton.backgroundColor = ConstantsColor.kMainColor
        previewButton.layer.cornerRadius = 15
        previewButton.addTarget(self, action: #selector(previewButtonTapped), for: .touchUpInside)

        firstDivider.backgroundColor = ConstantsColor.kDividerColor
        secondDivider.backgroundColor = ConstantsColor.kDividerColor
        thirdDivider.backgroundColor = ConstantsColor.kDividerColor

        descriptionHeadLabel.text = ConstantsBookDetailText.kBookDescriptionHead
        descriptionHeadLabel.font = UIFont.preferredFont(forTextStyle: .headline)

        descriptionBodyLabel.textAlignment = .left
        descriptionBodyLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        descriptionBodyLabel.numberOfLines = ConstantsNumber.kZero
        descriptionBodyLabel.isUserInteractionEnabled = true

        authorDescriptionHeadLabel.text = ConstantsBookDetailText.kAuthorDescriptionHead
        authorDescriptionHeadLabel.font = UIFont.preferredFont(forTextStyle: .headline)

        authorDescriptionBodyLabel.textAlignment = .left
        authorDescriptionBodyLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        authorDescriptionBodyLabel.numberOfLines = ConstantsNumber.kZero
        authorDescriptionBodyLabel.isUserInteractionEnabled = true

        memoTextView.text = ConstantsBookDetailText.kMemoPlaceholder
        memoTextView.font = UIFont.preferredFont(forTextStyle: .caption1)
        memoTextView.textColor = ConstantsColor.kGrayTextColor
        memoTextView.backgroundColor = ConstantsBookDetailColor.kMemoBackground
        memoTextView.delegate = self

        collaboratorLabel.textAlignment = .center
        collaboratorLabel.text = ConstantsString.kInformationProviderText
        collaboratorLabel.font = UIFont.preferredFont(forTextStyle: .caption2)
        collaboratorLabel.textColor = .gray

        // MARK: - Custom Constraints

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),

            backgroundView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            backgroundView.topAnchor.constraint(equalTo: entireInformationView.topAnchor, constant: 250),

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

            secondDivider.topAnchor.constraint(equalTo: descriptionBodyLabel.bottomAnchor, constant: 10),
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
            memoTextView.heightAnchor.constraint(equalToConstant: 200),

            collaboratorLabel.topAnchor.constraint(equalTo: memoTextView.bottomAnchor, constant: 10),
            collaboratorLabel.leadingAnchor.constraint(equalTo: entireInformationView.leadingAnchor, constant: 20),
            collaboratorLabel.trailingAnchor.constraint(equalTo: entireInformationView.trailingAnchor, constant: -20),
            collaboratorLabel.bottomAnchor.constraint(equalTo: entireInformationView.bottomAnchor, constant: -37)
        ])
    }

    private func setPartialColor(with labelText: String) -> NSMutableAttributedString {
        let fullString = labelText
        let attributedString = NSMutableAttributedString(string: fullString)
        let range = NSRange(location: fullString.count - ConstantsNumber.kAttributeLength, length: ConstantsNumber.kAttributeLength)
        attributedString.addAttribute(.foregroundColor,
                                      value: ConstantsColor.kMainColor,
                                      range: range)

        return attributedString
    }

    private func checkLabelSafety(with label: DynamicLabel) {
        guard let LabelText = label.fullText, LabelText.count > label.truncatedLength + label.attributedLength else {
            label.text = label.fullText
            return
        }

        label.collapse()
        label.attributedText = setPartialColor(with: label.text ?? ConstantsString.kBlank)
    }

    private func addKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// MARK: - @objc Functions

extension BookDetailViewController {
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        guard let keyboardRect: CGRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
              let tabBarHeight: CGFloat = self.tabBarController?.tabBar.frame.size.height else {
            return
        }

        if self.view.frame.origin.y == CGFloat(ConstantsNumber.kZero) {
            self.view.frame.origin.y -= (keyboardRect.height - tabBarHeight)
        }
    }

    @objc private func keyboardWillHide(_ notification: NSNotification) {
        if self.view.frame.origin.y != CGFloat(ConstantsNumber.kZero) {
            self.view.frame.origin.y = CGFloat(ConstantsNumber.kZero)
        }
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc private func controlDescription() {
        guard let labelText = descriptionBodyLabel.fullText, labelText.count > descriptionBodyLabel.truncatedLength + descriptionBodyLabel.attributedLength else {
            return
        }

        descriptionBodyLabel.isTruncated ? descriptionBodyLabel.expand() : descriptionBodyLabel.collapse()
        descriptionBodyLabel.attributedText = setPartialColor(with: descriptionBodyLabel.text ?? ConstantsString.kBlank)
    }

    @objc private func controlAuthorDescription() {
        guard let labelText = authorDescriptionBodyLabel.fullText, labelText.count > authorDescriptionBodyLabel.truncatedLength + authorDescriptionBodyLabel.attributedLength else {
            return
        }

        authorDescriptionBodyLabel.isTruncated ? authorDescriptionBodyLabel.expand() : authorDescriptionBodyLabel.collapse()
        authorDescriptionBodyLabel.attributedText = setPartialColor(with: authorDescriptionBodyLabel.text ?? ConstantsString.kBlank)
    }

    @objc private func previewButtonTapped() {
        let previewViewController = PreviewViewController()

        previewViewController.modalPresentationStyle = .overFullScreen
        previewViewController.imageLinks = imageLinks

        present(previewViewController, animated: true)
    }

    @objc private func favoritesButtonTouched() {
        var favoritesItems = UserDefaults.standard.stringArray(forKey: ConstantsFavorites.favoritesTextForKey) ?? []

        if let index = favoritesItems.firstIndex(of: selectedItem) {
            favoritesButton.tintColor = .white
            favoritesItems.remove(at: index)
        } else {
            favoritesButton.tintColor = ConstantsFavorites.kColor
            favoritesItems.append(selectedItem)
        }

        UserDefaults.standard.set(favoritesItems, forKey: ConstantsFavorites.favoritesTextForKey)
    }
}

// MARK: - TextViewDelegate

extension BookDetailViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == ConstantsBookDetailText.kMemoPlaceholder {
            textView.text = nil
            textView.textColor = .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = ConstantsBookDetailText.kMemoPlaceholder
            textView.textColor = ConstantsColor.kGrayTextColor
        }
    }
}
