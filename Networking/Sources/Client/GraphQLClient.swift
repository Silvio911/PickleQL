import Apollo
import Foundation
import Interfaces
import PickleAPI

/// A protocol that defines methods for fetching characters from a remote data source.
public protocol Client {
    /// Fetches a list of characters.
    func fetchCharacters() async throws -> [Character]?

    /// Fetches characters for the specified number of pages.
    ///
    /// - Parameter number: The number of pages to fetch characters from.
    func fetchFirstPages(_ number: Int) async throws -> [Character]?
}

public final class GraphQLClient: Client {
    /// Default GraphQL API URL, ideally sourced from a configuration file.
    private static let defaultURL: URL = {
        guard let url = URL(string: "https://rickandmortyapi.com/graphql") else {
            preconditionFailure("Invalid GraphQL API URL")
        }
        return url
    }()

    /// The Apollo client that is used to perform the network requests.
    private let apolloClient: ApolloClient

    public init() {
        self.apolloClient = ApolloClient(url: Self.defaultURL)
    }

    // MARK: Public API

    /// Fetches a list of characters.
    public func fetchCharacters() async throws -> [Character]? {
        guard let results = try await apolloClient
            .execute(CharactersQuery(page: .null))
            .data?
            .characters?
            .results
        else { return nil }

        return results.compactMap {
            guard
                let id = $0?.id,
                let name = $0?.name,
                let species = $0?.species,
                let gender = $0?.gender,
                let image = $0?.image
            else { return nil }

            return Character(id: id, name: name, species: species, gender: Gender(gender), image: image)
        }
    }

    /// Fetches characters for the specified number of pages.
    public func fetchFirstPages(_ number: Int) async throws -> [Character]? {
        var allCharacters: [Character] = []

        for page in 1...number {
            guard let results = try await apolloClient
                .execute(CharactersQuery(page: .some(page)))
                .data?
                .characters?
                .results
            else {
                return nil
            }

            let characters: [Character] = results.compactMap {
                guard
                    let id = $0?.id,
                    let name = $0?.name,
                    let species = $0?.species,
                    let gender = $0?.gender,
                    let image = $0?.image
                else { return nil }

                return Character(id: id, name: name, species: species, gender: Gender(gender), image: image)
            }

            allCharacters.append(contentsOf: characters)
        }

        return allCharacters
    }
}
