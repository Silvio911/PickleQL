//
//  CharacterListViewModel.swift
//  PickleQL
//
//  Created by Silvio Bulla on 26.03.25.
//

import Foundation
import Interfaces
import Networking

@MainActor
final class CharacterListViewModel: ObservableObject {
    enum State: Equatable {
        case loading
        case content([Character])
        case empty
    }

    @Published private(set) var state: State = .loading

    private let client: GraphQLClient

    init(client: GraphQLClient = .init()) {
        self.client = client
    }

    func loadData() {
        Task {
            do {
                guard let characters = try await client.fetchCharacters() else {
                    state = .empty
                    return
                }

                state = characters.isEmpty ? .empty : .content(characters)
            } catch {
                state = .empty
            }
        }
    }
}
