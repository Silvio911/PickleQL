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
    // MARK: - Properties

    typealias DataSource = UICollectionViewDiffableDataSource<String, Character>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<String, Character>

    private lazy var dataSource: UICollectionViewDiffableDataSource<String, Character> = makeDataSource()
    private var cancellables = Set<AnyCancellable>()

    private var layoutType: LayoutType = .list
    private var viewModel: CharacterListViewModel
    private let viewHelper = CharacterListViewHelper()

    // MARK: UI Components

    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["All", "Female"])
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(segmentedControlChanged(_:)), for: .valueChanged)
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = viewHelper.createLayout(for: .list)
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

    // MARK: - Init

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

    // MARK: - Subscription

    private func subscribe() {
        viewModel.$state
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                switch state {
                case .loading:
                    self?.updateLoadingView(isLoading: true)
                    self?.applyDataSourceSnapshot([:])
                    self?.updateErrorView(display: false)
                case .content(let characters):
                    self?.updateLoadingView(isLoading: false)
                    self?.applyDataSourceSnapshot(characters)
                    self?.updateErrorView(display: false)
                case .empty:
                    self?.applyDataSourceSnapshot([:])
                    self?.updateLoadingView(isLoading: false)
                    self?.updateErrorView(display: true)
                }
            }
            .store(in: &cancellables)
    }

    private func setupViews() {
        title = "Characters"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.titleView = segmentedControl

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

    // MARK: - Layout

    @objc private func segmentedControlChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            viewModel.loadFemaleCharacters()
            layoutType = .orthogonal
        } else {
            viewModel.loadData()
            layoutType = .list
        }

        collectionView.setCollectionViewLayout(viewHelper.createLayout(for: layoutType), animated: true)
    }

    private func makeDataSource() -> DataSource {
        let listCell = UICollectionView.CellRegistration<CharacterListCell, Character> { cell, _, character in
            cell.configure(with: character)
        }
        let orthogonalCell = UICollectionView.CellRegistration<OrthogonalCell, Character> { cell, _, character in
            cell.configure(with: character)
        }

        let headerRegistration = UICollectionView.SupplementaryRegistration<UICollectionViewListCell>(
            elementKind: UICollectionView.elementKindSectionHeader
        ) { cell, _, indexPath in
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]

            var content = UIListContentConfiguration.header()
            content.text = section
            content.textProperties.font = .preferredFont(forTextStyle: .headline)
            content.textProperties.color = .label

            cell.contentConfiguration = content
        }

        let dataSource = UICollectionViewDiffableDataSource<String, Character>(
            collectionView: collectionView
        ) { collectionView, indexPath, character in
            if self.layoutType == .orthogonal {
                return collectionView.dequeueConfiguredReusableCell(using: orthogonalCell, for: indexPath, item: character)
            } else {
                return collectionView.dequeueConfiguredReusableCell(using: listCell, for: indexPath, item: character)
            }
        }

        dataSource.supplementaryViewProvider = { collectionView, _, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }

        return dataSource
    }

    private func applyDataSourceSnapshot(_ groupedCharacters: [String: [Character]]) {
        var snapshot = DataSourceSnapshot()

        for (sectionTitle, charactersInSection) in groupedCharacters {
            snapshot.appendSections([sectionTitle])
            snapshot.appendItems(charactersInSection, toSection: sectionTitle)
        }

        dataSource.apply(snapshot, animatingDifferences: true)
    }

    // MARK: - Helpers

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
