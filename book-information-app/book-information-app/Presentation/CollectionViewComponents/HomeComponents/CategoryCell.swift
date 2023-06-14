//
//  CategoryCell.swift
//  book-information-app
//
//  Created by 이상윤 on 2023/05/24.
//

import UIKit

final class CategoryCell: UICollectionViewCell {
    static let reuseIdentifier = ConstantsReuseIdentifier.kCategory

    let categoryLabel = UILabel()
    var categoryID: String = ConstantsString.kBlank
}

extension CategoryCell {
    func applyGradientBackground() {
        let gradientLayer = CAGradientLayer()

        gradientLayer.frame = contentView.bounds
        gradientLayer.colors = [ConstantsColor.kMainColor.cgColor, ConstantsCategoryCell.kGradientSubColor.cgColor]
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.cornerRadius = 15

        contentView.layer.insertSublayer(gradientLayer, at: 0)
    }

    func removeGradientBackground() {
        contentView.layer.sublayers?.removeFirst()
    }
    
    func configure(with categoryItem: HomeController.Category) {
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(categoryLabel)

        categoryLabel.text = categoryItem.title
        categoryLabel.textAlignment = .center
        categoryLabel.textColor = .black

        if let categoryID = CategoryID.categoryIDList.first(where: {$0.value == categoryItem.title })?.key {
            self.categoryID = String(categoryID)
        }

        self.backgroundColor = ConstantsCategoryCell.kBackgroundColor
        self.layer.cornerRadius = 15

        NSLayoutConstraint.activate([
            categoryLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            categoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            categoryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
