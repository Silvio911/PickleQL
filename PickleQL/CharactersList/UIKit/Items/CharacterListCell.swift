//
//  CharacterTableViewCell.swift
//  PickleQL
//
//  Created by Silvio Bulla on 27.03.25.
//

import Interfaces
import Nuke
import UIKit

final class CharacterListCell: UICollectionViewListCell {
    // MARK: - UI Components

    private lazy var icon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray6
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        return label
    }()

    private lazy var thirdLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.textColor = .gray
        label.textAlignment = .right
        return label
    }()

    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [icon, textStackView, thirdLabel])
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        icon.image = nil
        titleLabel.text = nil
        subtitleLabel.text = nil
        thirdLabel.text = nil
    }

    // MARK: - Configuration

    func configure(with character: Character) {
        titleLabel.text = character.name
        subtitleLabel.text = character.species
        thirdLabel.text = character.gender.emoji
        loadImage(character.image)
    }

    // MARK: - Private methods

    private func setupViews() {
        contentView.addSubview(mainStackView)

        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

            separatorLayoutGuide.leadingAnchor.constraint(equalTo: textStackView.leadingAnchor),
        ])
    }

    private func loadImage(_ imageURL: String) {
        Task {
            if let url = URL(string: imageURL) {
                let image = try? await ImagePipeline.shared.image(for: url)
                icon.image = image
            }
        }
    }
}
