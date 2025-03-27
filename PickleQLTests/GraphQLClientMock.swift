//
//  GraphQLClientMock.swift
//  PickleQL
//
//  Created by Silvio Bulla on 27.03.25.
//

import Interfaces
import Networking

final class GraphQLClientMock: Client {
    func fetchCharacters() async throws -> [Character]? {
        [.init(id: "1", name: "Rick", species: "Human", gender: .male, image: "")]
    }
    
    func fetchFirstPages(_ number: Int) async throws -> [Character]? {
        [
            .init(id: "1", name: "Rick", species: "Human", gender: .male, image: ""),
            .init(id: "2", name: "Morty", species: "Human", gender: .male, image: "")
        ]
    }
}
