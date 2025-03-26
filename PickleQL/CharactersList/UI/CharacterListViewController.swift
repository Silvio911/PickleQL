//
//  CharacterListViewController.swift
//  PickleQL
//
//  Created by Silvio Bulla on 26.03.25.
//

import Combine
import Interfaces
import UIKit

final class CharacterListViewController: UIViewController {
    // MARK: Properties

    typealias DataSource = UICollectionViewDiffableDataSource<String, Character>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<String, Character>

    private lazy var dataSource: UICollectionViewDiffableDataSource<String, Character> = makeDataSource()
    private var cancellables = Set<AnyCancellable>()
    private var viewModel: CharacterListViewModel

    // MARK: UI Components

    private lazy var collectionView: UICollectionView = {
        let layout = createListLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset = .zero
        return collectionView
    }()

    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.startAnimating()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var emptyView: UIContentUnavailableView = {
        var viewConfig = UIContentUnavailableConfiguration.empty()
        viewConfig.text = "No Characters found"
        viewConfig.image = UIImage(systemName: "exclamationmark.triangle")

        var buttonConfig = UIButton.Configuration.filled()
        buttonConfig.title = "Retry"
        viewConfig.button = buttonConfig
        viewConfig.buttonProperties.primaryAction = UIAction { [weak self] _ in
            self?.viewModel.loadData()
        }

        let view = UIContentUnavailableView(configuration: viewConfig)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()

    // MARK: Init

    init(viewModel: CharacterListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)

        viewModel.loadData()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        subscribe()
    }

    // MARK: Subscription

    private func subscribe() {
        viewModel.$state
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                switch state {
                case .loading:
                    self?.updateLoadingView(isLoading: true)
                    self?.applyDataSourceSnapshot(characters: [])
                    self?.updateErrorView(display: false)
                case .content(let characters):
                    self?.updateLoadingView(isLoading: false)
                    self?.applyDataSourceSnapshot(characters: characters)
                    self?.updateErrorView(display: false)
                case .empty:
                    self?.applyDataSourceSnapshot(characters: [])
                    self?.updateLoadingView(isLoading: false)
                    self?.updateErrorView(display: true)
                }
            }
            .store(in: &cancellables)
    }

    // MARK: Private methods

    private func setupViews() {
        title = "Characters"
        view.backgroundColor = .gray
        collectionView.dataSource = dataSource
        [collectionView, loadingIndicator, emptyView].forEach {
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            emptyView.topAnchor.constraint(equalTo: view.topAnchor),
            emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            emptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func createListLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { _, layoutEnvironment in
            var layoutConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
            layoutConfiguration.headerMode = .supplementary
            layoutConfiguration.showsSeparators = true
            layoutConfiguration.backgroundColor = .systemBackground
            let layoutSection = NSCollectionLayoutSection.list(
                using: layoutConfiguration,
                layoutEnvironment: layoutEnvironment
            )
            layoutSection.interGroupSpacing = .zero
            layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: .zero, bottom: 16, trailing: .zero)
            return layoutSection
        }
    }

    private func makeDataSource() -> DataSource {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Character> { cell, _, character in
            var content = UIListContentConfiguration.cell()
            content.text = character.name
            content.secondaryText = character.species
            cell.contentConfiguration = content
        }

        let headerRegistration = UICollectionView.SupplementaryRegistration<UICollectionViewListCell>(elementKind: UICollectionView.elementKindSectionHeader) { cell, _, indexPath in
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]

            var content = UIListContentConfiguration.header()
            content.text = section
            cell.contentConfiguration = content
        }

        let dataSource = UICollectionViewDiffableDataSource<String, Character>(collectionView: collectionView) { collectionView, indexPath, character in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: character)
        }

        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }

        return dataSource
    }

    private func applyDataSourceSnapshot(characters: [Character]) {
        let groupedCharacters = Dictionary(grouping: characters, by: { $0.species })
        var snapshot = DataSourceSnapshot()

        let sortedSpecies = groupedCharacters.keys.sorted()

        for species in sortedSpecies {
            snapshot.appendSections([species])

            if let characters = groupedCharacters[species] {
                snapshot.appendItems(characters, toSection: species)
            }
        }

        dataSource.apply(snapshot, animatingDifferences: true)
    }

    private func updateLoadingView(isLoading: Bool) {
        if isLoading {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
        loadingIndicator.isHidden = !isLoading
    }

    private func updateErrorView(display: Bool) {
        emptyView.isHidden = !display
    }
}
