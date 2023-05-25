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

        contentView.addSubview(bookStackView)
        bookStackView.addArrangedSubview(bookImageView)
        bookStackView.addArrangedSubview(booktitleLabel)
        bookStackView.addArrangedSubview(bookAuthorLabel)

        bookStackView.axis = .vertical
        bookStackView.spacing = 3

        bookImageView.layer.borderColor = UIColor.black.cgColor
        bookImageView.layer.borderWidth = 1
        bookImageView.layer.cornerRadius = 4
        bookImageView.image = .actions

        booktitleLabel.font = UIFont.preferredFont(forTextStyle: .caption1)
        booktitleLabel.adjustsFontForContentSizeCategory = true
        booktitleLabel.textAlignment = .center

        bookAuthorLabel.font = UIFont.preferredFont(forTextStyle: .caption2)
        bookAuthorLabel.adjustsFontForContentSizeCategory = true
        bookAuthorLabel.textColor = UIColor(red: 0.29, green: 0.31, blue: 0.34, alpha: 1.00)
        bookAuthorLabel.textAlignment = .center

        NSLayoutConstraint.activate([
            bookStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bookStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            bookStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bookStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
