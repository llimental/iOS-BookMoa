//
//  BestSellerCell.swift
//  book-information-app
//
//  Created by 이상윤 on 2023/05/22.
//

import UIKit

final class BestSellerCell: UICollectionViewCell {
    static let reuseIdentifier = MagicLiteral.bestSellerReuseIdentifier

    let bookImageView = UIImageView()
    let booktitleLabel = UILabel()
    let bookAuthorLabel = UILabel()
    var bookISBN: String = ""

    private let bookStackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension BestSellerCell {
    private func configure() {
        bookStackView.translatesAutoresizingMaskIntoConstraints = false
        bookImageView.translatesAutoresizingMaskIntoConstraints = false
        booktitleLabel.translatesAutoresizingMaskIntoConstraints = false
        bookAuthorLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(bookStackView)
        bookStackView.addSubview(bookImageView)
        bookStackView.addSubview(booktitleLabel)
        bookStackView.addSubview(bookAuthorLabel)

        bookStackView.axis = .vertical

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

            bookImageView.topAnchor.constraint(equalTo: bookStackView.topAnchor),
            bookImageView.leadingAnchor.constraint(equalTo: bookStackView.leadingAnchor),
            bookImageView.trailingAnchor.constraint(equalTo: bookStackView.trailingAnchor),
            bookImageView.heightAnchor.constraint(equalToConstant: 180),

            booktitleLabel.topAnchor.constraint(equalTo: bookImageView.bottomAnchor, constant: 4),
            booktitleLabel.leadingAnchor.constraint(equalTo: bookStackView.leadingAnchor),
            booktitleLabel.trailingAnchor.constraint(equalTo: bookStackView.trailingAnchor),
            booktitleLabel.heightAnchor.constraint(equalToConstant: 15),

            bookAuthorLabel.topAnchor.constraint(equalTo: booktitleLabel.bottomAnchor, constant: 2),
            bookAuthorLabel.leadingAnchor.constraint(equalTo: bookStackView.leadingAnchor),
            bookAuthorLabel.trailingAnchor.constraint(equalTo: bookStackView.trailingAnchor),
            bookAuthorLabel.bottomAnchor.constraint(equalTo: bookStackView.bottomAnchor)
        ])
    }
}
