//
//  CategoryCell.swift
//  book-information-app
//
//  Created by 이상윤 on 2023/05/24.
//

import UIKit

final class CategoryCell: UICollectionViewCell {
    static let reuseIdentifier = MagicLiteral.categoryReuseIdentifier

    let categoryLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension CategoryCell {
    private func configure() {
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(categoryLabel)

        categoryLabel.textAlignment = .center
        categoryLabel.textColor = .black

        self.backgroundColor = UIColor(red: 0.87, green: 0.89, blue: 0.90, alpha: 1.00)
        self.layer.cornerRadius = 15

        NSLayoutConstraint.activate([
            categoryLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            categoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            categoryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
