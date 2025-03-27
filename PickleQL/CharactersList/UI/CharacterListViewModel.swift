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
        case content([String: [Character]])
        case empty
    }

    @Published private(set) var state: State = .loading
    var currentCharacters: [String: [Character]] = [:]

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

                currentCharacters = Dictionary(grouping: characters, by: { $0.species })
                state = characters.isEmpty ? .empty : .content(currentCharacters)
            } catch {
                state = .empty
            }
        }
    }

    func loadFemaleCharacters() {
        let femaleCharacters = currentCharacters
            .compactMapValues { $0.filter { $0.gender == .female } }
            .filter { !$0.value.isEmpty }

        state = femaleCharacters.isEmpty
        ? .empty
        : .content(["Female": femaleCharacters.values.flatMap { $0 }.sorted { $0.name < $1.name } ])
    }
}
