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
    var categoryID: String = ConstantsString.kBlank

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension CategoryCell {
    func applyGradientBackground() {
        let gradientLayer = CAGradientLayer()

        gradientLayer.frame = contentView.bounds
        gradientLayer.colors = [ConstantsColor.kMainColor.cgColor, UIColor(red: 0.49, green: 0.31, blue: 0.91, alpha: 1.00).cgColor]
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.cornerRadius = 15

        contentView.layer.insertSublayer(gradientLayer, at: 0)
    }

    func removeGradientBackground() {
        contentView.layer.sublayers?.removeFirst()
    }
    
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
