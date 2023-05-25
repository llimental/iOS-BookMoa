//
//  TitleSupplementaryView.swift
//  book-information-app
//
//  Created by 이상윤 on 2023/05/22.
//

import UIKit

final class TitleSupplementaryView: UICollectionReusableView {
    static let reuseIdentifier = MagicLiteral.supplementaryReuseIdentifier

    let titleLabel = UILabel()

    private let titleStackView = UIStackView()
    private let disclosureImageView = UIImageView()
    
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
        titleStackView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(titleStackView)
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(disclosureImageView)

        titleStackView.axis = .horizontal
        
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.textColor = .black
        titleLabel.font = UIFont.boldSystemFont(ofSize: 20)

        disclosureImageView.image = UIImage(systemName: "chevron.right")
        disclosureImageView.tintColor = .black

        NSLayoutConstraint.activate([
            titleStackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            titleStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            titleStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),
            titleStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
        ])
    }
}
