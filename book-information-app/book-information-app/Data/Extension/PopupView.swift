//
//  PopupView.swift
//  book-information-app
//
//  Created by 이상윤 on 2023/05/30.
//

import UIKit

final class PopupView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var imageIndex = 0 {
        didSet {
            updateImageView()
        }
    }

    var imageLinks: [String] = [] {
        didSet {
            updateImageView()
        }
    }

    private let entireStackView: UIStackView = {
        let entireStackView = UIStackView()

        entireStackView.translatesAutoresizingMaskIntoConstraints = false

        return entireStackView
    }()

    private let backgroundView: UIView = {
        let view = UIView()

        view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private let imageView: UIImageView = {
        let imageView = UIImageView()

        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false

        return imageView
    }()

    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()

        stackView.translatesAutoresizingMaskIntoConstraints = false

        return stackView
    }()

    private let previousButton: UIButton = {
        let button = UIButton(type: .system)

        button.setTitle("이전", for: .normal)
        button.setTitleColor(.white, for: .normal)

        return button
    }()

    private let nextButton: UIButton = {
        let button = UIButton(type: .system)

        button.setTitle("다음", for: .normal)
        button.setTitleColor(.white, for: .normal)

        return button
    }()

    private let closeButton: UIButton = {
        let button = UIButton(type: .system)

        button.setTitle("닫기", for: .normal)

        return button
    }()
}

extension PopupView {
    private func setupViews() {
        addSubview(entireStackView)

        entireStackView.addSubview(backgroundView)
        entireStackView.addSubview(imageView)
        entireStackView.addSubview(buttonStackView)

        buttonStackView.addArrangedSubview(previousButton)
        buttonStackView.addArrangedSubview(closeButton)
        buttonStackView.addArrangedSubview(nextButton)

        entireStackView.axis = .vertical

        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .equalSpacing

        closeButton.tintColor = .white

        NSLayoutConstraint.activate([
            entireStackView.topAnchor.constraint(equalTo: topAnchor),
            entireStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            entireStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            entireStackView.bottomAnchor.constraint(equalTo: bottomAnchor),

            backgroundView.topAnchor.constraint(equalTo: entireStackView.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: entireStackView.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: entireStackView.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: entireStackView.bottomAnchor),

            imageView.topAnchor.constraint(equalTo: entireStackView.topAnchor, constant: 15),
            imageView.leadingAnchor.constraint(equalTo: entireStackView.leadingAnchor, constant: 15),
            imageView.trailingAnchor.constraint(equalTo: entireStackView.trailingAnchor, constant: -15),

            buttonStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 15),
            buttonStackView.leadingAnchor.constraint(equalTo: entireStackView.leadingAnchor, constant: 15),
            buttonStackView.trailingAnchor.constraint(equalTo: entireStackView.trailingAnchor, constant: -15),
            buttonStackView.bottomAnchor.constraint(equalTo: entireStackView.bottomAnchor, constant: -15)
        ])

        previousButton.addTarget(self, action: #selector(previousButtonTapped), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }

    private func updateImageView() {
        guard imageLinks.indices.contains(imageIndex) else {
            imageView.image = nil
            return
        }

        guard let url = URL(string: imageLinks[imageIndex]) else {
            imageView.image = nil
            return
        }
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data)
                }
            } else {
                DispatchQueue.main.async {
                    self.imageView.image = nil
                }
            }
        }
    }

    @objc private func previousButtonTapped() {
        if imageIndex > 0 {
            imageIndex -= 1
        }
    }

    @objc private func nextButtonTapped() {
        if imageIndex < imageLinks.count - 1 {
            imageIndex += 1
        }
    }

    @objc private func closeButtonTapped() {
        removeFromSuperview()
    }
}
