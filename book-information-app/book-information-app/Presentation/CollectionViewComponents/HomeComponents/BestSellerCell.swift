//
//  BestSellerCell.swift
//  book-information-app
//
//  Created by 이상윤 on 2023/05/22.
//

import UIKit

final class BestSellerCell: UICollectionViewCell {
    static let reuseIdentifier = ConstantsReuseIdentifier.kBestSeller

    let bookImageView = UIImageView()
    let booktitleLabel = UILabel()
    let bookAuthorLabel = UILabel()
    var bookISBN: String = ConstantsString.kBlank

    private let bookStackView = UIStackView()
}

extension BestSellerCell {
    func configure(with bookItem: HomeController.Book) {
        bookStackView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(bookStackView)
        bookStackView.addArrangedSubview(bookImageView)
        bookStackView.addArrangedSubview(booktitleLabel)
        bookStackView.addArrangedSubview(bookAuthorLabel)

        bookStackView.axis = .vertical
        bookStackView.alignment = .center
        bookStackView.distribution = .equalSpacing

        bookISBN = bookItem.isbn

        bookImageView.contentMode = .scaleAspectFit
        bookImageView.image = bookItem.cover

        booktitleLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        booktitleLabel.text = bookItem.title
        booktitleLabel.adjustsFontForContentSizeCategory = true

        bookAuthorLabel.font = UIFont.preferredFont(forTextStyle: .caption2)
        bookAuthorLabel.text = bookItem.author
        bookAuthorLabel.adjustsFontForContentSizeCategory = true
        bookAuthorLabel.textColor = ConstantsColor.kGrayTextColor

        NSLayoutConstraint.activate([
            bookStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bookStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bookStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bookStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            bookImageView.heightAnchor.constraint(equalTo: bookStackView.heightAnchor, multiplier: 0.8),
            bookImageView.widthAnchor.constraint(equalTo: bookStackView.widthAnchor)
        ])
    }
}
