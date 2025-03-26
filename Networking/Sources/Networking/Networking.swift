// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import Apollo
import PickleAPI

internal final class Networking {
    static let shared = Networking()

    private(set) lazy var apollo = ApolloClient(url: URL(string: "https://rickandmortyapi.com/graphql")!)
}

public class Client {
    public init() {
        Networking.shared.apollo.fetch(query: CharactersQuery(page: 1)) { result in
            switch result {
            case .success(let data):
                print("Date: ", data.asJSONDictionary())
            case .failure(let error):
                print("Error: ", error)
            }
        }
    }
}
