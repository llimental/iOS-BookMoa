//
//  CategoryBookCell.swift
//  book-information-app
//
//  Created by 이상윤 on 2023/05/31.
//

import UIKit

final class CategoryBookCell: UICollectionViewCell {
    static let reuseIdentifier = MagicLiteral.categoryBookReuseIdentifier

    let bookImageView = UIImageView()
    let booktitleLabel = UILabel()
    let bookAuthorLabel = UILabel()
    var bookISBN: String = ConstantsString.kBlank

    let favoritesImageView = UIImageView()

    private let bookStackView = UIStackView()
}

extension CategoryBookCell {
    func configure(with item: CategoryController.CategoryBook) {
        bookStackView.translatesAutoresizingMaskIntoConstraints = false
        favoritesImageView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(bookStackView)
        contentView.addSubview(favoritesImageView)
        bookStackView.addArrangedSubview(bookImageView)
        bookStackView.addArrangedSubview(booktitleLabel)
        bookStackView.addArrangedSubview(bookAuthorLabel)

        bookStackView.axis = .vertical
        bookStackView.spacing = 3
        bookStackView.alignment = .center
        bookStackView.distribution = .equalSpacing

        bookISBN = item.isbn

        bookImageView.contentMode = .scaleAspectFit
        bookImageView.image = item.cover

        favoritesImageView.image = UIImage(systemName: "heart.square.fill")
        favoritesImageView.tintColor = ConstantsColor.kMainColor

        if let favoritesItems = UserDefaults.standard.stringArray(forKey: MagicLiteral.favoritesTextForKey), favoritesItems.contains(bookISBN) {
            favoritesImageView.backgroundColor = UIColor(red: 0.88, green: 0.04, blue: 0.55, alpha: 1.00)
        } else {
            favoritesImageView.backgroundColor = .white
        }

        booktitleLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        booktitleLabel.text = item.title
        booktitleLabel.adjustsFontForContentSizeCategory = true
        booktitleLabel.textAlignment = .center

        bookAuthorLabel.font = UIFont.preferredFont(forTextStyle: .caption2)
        bookAuthorLabel.text = item.author
        bookAuthorLabel.adjustsFontForContentSizeCategory = true
        bookAuthorLabel.textColor = UIColor(red: 0.29, green: 0.31, blue: 0.34, alpha: 1.00)
        bookAuthorLabel.textAlignment = .center

        NSLayoutConstraint.activate([
            bookStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bookStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bookStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bookStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            favoritesImageView.topAnchor.constraint(equalTo: bookImageView.topAnchor),
            favoritesImageView.trailingAnchor.constraint(equalTo: bookImageView.trailingAnchor),
            favoritesImageView.widthAnchor.constraint(equalTo: bookImageView.widthAnchor, multiplier: 0.2),
            favoritesImageView.heightAnchor.constraint(equalTo: bookImageView.heightAnchor, multiplier: 1.0 / 7.0)
        ])
    }
}
