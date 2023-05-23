//
//  TitleSupplementaryView.swift
//  book-information-app
//
//  Created by 이상윤 on 2023/05/22.
//

import UIKit

final class TitleSupplementaryView: UICollectionReusableView {
    let titleStackView = UIStackView()
    let titleLabel = UILabel()
    let disclosureImageView = UIImageView()

    static let reuseIdentifier = MagicLiteral.supplementaryReuseIdentifier

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension TitleSupplementaryView {
    private func configure() {
        addSubview(titleStackView)
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(disclosureImageView)

        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        titleStackView.axis = .horizontal

        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)

        disclosureImageView.image = UIImage(systemName: "chevron.right")
        disclosureImageView.tintColor = .yellow

        NSLayoutConstraint.activate([
            titleStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            titleStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10)
        ])
    }
}
