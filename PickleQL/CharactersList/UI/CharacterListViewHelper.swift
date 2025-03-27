//
//  CharacterListViewHelper.swift
//  PickleQL
//
//  Created by Silvio Bulla on 27.03.25.
//

import UIKit

/// Helper to manage collection view layouts.
struct CharacterListViewHelper {
    func createLayout(for type: LayoutType) -> UICollectionViewCompositionalLayout {
        switch type {
        case .list:
            return createListLayout()
        case .orthogonal:
            return createOrthogonalScrollingLayout()
        }
    }

    private func createListLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { _, layoutEnvironment in
            var layoutConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
            layoutConfiguration.headerMode = .supplementary

            let layoutSection = NSCollectionLayoutSection.list(
                using: layoutConfiguration,
                layoutEnvironment: layoutEnvironment
            )
            layoutSection.interGroupSpacing = .zero
            layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: .zero, bottom: 8, trailing: 0)
            return layoutSection
        }
    }

    private func createOrthogonalScrollingLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { _, _ in
            let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(120)
            ))

            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1/3),
                    heightDimension: .estimated(120)
                ),
                subitems: [item]
            )

            let layoutSection = NSCollectionLayoutSection(group: group)
            layoutSection.interGroupSpacing = 8
            layoutSection.orthogonalScrollingBehavior = .continuous
            layoutSection.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)

            layoutSection.boundarySupplementaryItems = [
                NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .estimated(40)
                    ),
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .top
                )
            ]
            return layoutSection
        }
    }
}
