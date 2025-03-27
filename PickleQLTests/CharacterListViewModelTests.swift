//
//  PickleQLTests.swift
//  PickleQLTests
//
//  Created by Silvio Bulla on 23.03.25.
//

import Interfaces
@testable import PickleQL
import Testing

@MainActor
struct CharacterListViewModelTests {
    private let client: GraphQLClientMock
    private let sut: CharacterListViewModel

    init() {
        client = GraphQLClientMock()
        self.sut = CharacterListViewModel(client: client)
    }

    @Test func loadData() async throws {
        // Given
        let expectedCharacters = [ "Human": [
            Character(id: "1", name: "Rick", species: "Human", gender: .male, image: ""),
            Character(id: "2", name: "Morty", species: "Human", gender: .male, image: "")
        ]]

        // When
        sut.loadData()

        try? await Task.sleep(for: .seconds(2))

        // Then
        #expect(sut.currentCharacters == expectedCharacters)
    }

    @Test func loadFemaleCharacters() async throws {
        sut.currentCharacters = [
            "Female": [.init(id: "3", name: "Beth", species: "Human", gender: .female, image: "")],
            "Male": [.init(id: "1", name: "Rick", species: "Human", gender: .male, image: "")]
        ]

        sut.loadFemaleCharacters()

        #expect(sut.state == .content(["Female": [.init(id: "3", name: "Beth", species: "Human", gender: .female, image: "")]]))
    }

}
