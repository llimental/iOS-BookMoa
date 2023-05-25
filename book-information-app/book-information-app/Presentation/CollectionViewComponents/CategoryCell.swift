//
//  CategoryCell.swift
//  book-information-app
//
//  Created by 이상윤 on 2023/05/24.
//

import UIKit

final class CategoryCell: UICollectionViewCell {
    static let reuseIdentifier = MagicLiteral.categoryReuseIdentifier

    let categoryButton = UIButton()

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
        categoryButton.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(categoryButton)

        categoryButton.layer.cornerRadius = 15
        categoryButton.setTitleColor(.black, for: .normal)
        categoryButton.backgroundColor = UIColor(red: 0.87, green: 0.89, blue: 0.90, alpha: 1.00)

        NSLayoutConstraint.activate([
            categoryButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            categoryButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            categoryButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            categoryButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
