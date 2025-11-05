import Interfaces
import Nuke
import UIKit

class OrthogonalCell: UICollectionViewCell {
    // MARK: - UI Components

    private lazy var icon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var titleLabelContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [icon, titleLabelContainer])
        stackView.axis = .vertical
        stackView.spacing = 8
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
    }

    // MARK: - Configuration

    func configure(with character: Character) {
        titleLabel.text = character.name
        loadImage(character.image)
    }

    // MARK: - Setup

    private func setupViews() {
        contentView.addSubview(mainStackView)
        titleLabelContainer.addSubview(titleLabel)
        contentView.backgroundColor = .systemGray6
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true

        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            titleLabel.topAnchor.constraint(equalTo: titleLabelContainer.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: titleLabelContainer.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: titleLabelContainer.trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(equalTo: titleLabelContainer.bottomAnchor, constant: -8),

            icon.heightAnchor.constraint(equalToConstant: 80),
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
