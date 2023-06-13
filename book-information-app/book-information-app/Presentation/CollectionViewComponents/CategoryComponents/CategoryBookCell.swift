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

    let bookmarkImageView = UIImageView()

    private let bookStackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension CategoryBookCell {
    private func configure() {
        bookStackView.translatesAutoresizingMaskIntoConstraints = false
        bookmarkImageView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(bookStackView)
        contentView.addSubview(bookmarkImageView)
        bookStackView.addArrangedSubview(bookImageView)
        bookStackView.addArrangedSubview(booktitleLabel)
        bookStackView.addArrangedSubview(bookAuthorLabel)

        bookStackView.axis = .vertical
        bookStackView.spacing = 3
        bookStackView.alignment = .center

        bookImageView.contentMode = .scaleAspectFit

        bookmarkImageView.image = UIImage(systemName: "heart.square.fill")
        bookmarkImageView.tintColor = ConstantsColor.kMainColor
        bookmarkImageView.backgroundColor = .white

        booktitleLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        booktitleLabel.adjustsFontForContentSizeCategory = true
        booktitleLabel.textAlignment = .center

        bookAuthorLabel.font = UIFont.preferredFont(forTextStyle: .caption2)
        bookAuthorLabel.adjustsFontForContentSizeCategory = true
        bookAuthorLabel.textColor = UIColor(red: 0.29, green: 0.31, blue: 0.34, alpha: 1.00)
        bookAuthorLabel.textAlignment = .center

        NSLayoutConstraint.activate([
            bookStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bookStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bookStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bookStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            bookmarkImageView.topAnchor.constraint(equalTo: bookImageView.topAnchor),
            bookmarkImageView.trailingAnchor.constraint(equalTo: bookImageView.trailingAnchor),
            bookmarkImageView.widthAnchor.constraint(equalTo: bookImageView.widthAnchor, multiplier: 0.2),
            bookmarkImageView.heightAnchor.constraint(equalTo: bookImageView.heightAnchor, multiplier: 1.0 / 7.0)
        ])
    }
}
