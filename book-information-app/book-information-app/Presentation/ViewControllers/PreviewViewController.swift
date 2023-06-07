//
//  PreviewViewController.swift
//  book-information-app
//
//  Created by 이상윤 on 2023/06/07.
//

import UIKit

final class PreviewViewController: UIViewController {

    // MARK: - Public Properties

    var imageIndex: Int = 0 {
        didSet {
            setPreviewImage()
        }
    }
    var imageLinks: [String] = [] {
        didSet {
            setPreviewImage()
        }
    }

    // MARK: - View LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }

    // MARK: - Private Properties

    private lazy var blurView = UIVisualEffectView(effect: blurEffect)
    private let blurEffect = UIBlurEffect(style: .light)
    private let previewContainerView = UIView()
    private let imageView = UIImageView()
    private let buttonStackView = UIStackView()
    private let previousButton = UIButton()
    private let nextButton = UIButton()
    private let closeButton = UIButton()
}

extension PreviewViewController {

    // MARK: - Private Functions

    private func configure() {
        view.addSubview(blurView)
        view.addSubview(previewContainerView)

        previewContainerView.addSubview(imageView)
        previewContainerView.addSubview(buttonStackView)

        buttonStackView.addArrangedSubview(previousButton)
        buttonStackView.addArrangedSubview(closeButton)
        buttonStackView.addArrangedSubview(nextButton)

        blurView.frame = view.bounds

        imageView.contentMode = .scaleAspectFit

        previousButton.setTitle("이전", for: .normal)
        previousButton.setTitleColor(.purple, for: .normal)
        previousButton.addTarget(self, action: #selector(previousButtonTapped), for: .touchUpInside)

        nextButton.setTitle("다음", for: .normal)
        nextButton.setTitleColor(.purple, for: .normal)
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)

        closeButton.setTitle("닫기", for: .normal)
        closeButton.setTitleColor(.black, for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)

        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 10
        buttonStackView.distribution = .fillEqually

        previewContainerView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            previewContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            previewContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            previewContainerView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            previewContainerView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.9),

            imageView.topAnchor.constraint(equalTo: previewContainerView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: previewContainerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: previewContainerView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: previewContainerView.heightAnchor, multiplier: 0.8),

            buttonStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            buttonStackView.leadingAnchor.constraint(equalTo: previewContainerView.leadingAnchor),
            buttonStackView.trailingAnchor.constraint(equalTo: previewContainerView.trailingAnchor),
            buttonStackView.bottomAnchor.constraint(equalTo: previewContainerView.bottomAnchor)
        ])
    }

    private func setPreviewImage() {
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
            }
        }
    }

    @objc private func previousButtonTapped() {
        if imageIndex > 0 {
            imageIndex -= 1
        }
    }

    @objc private func closeButtonTapped() {
        self.dismiss(animated: true)
    }

    @objc private func nextButtonTapped() {
        if imageIndex < imageLinks.count - 1 {
            imageIndex += 1
        }
    }
}
