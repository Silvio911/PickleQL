import Apollo
import Foundation
import Interfaces
import PickleAPI

public final class GraphQLClient {
    /// Default GraphQL API URL
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

            return Character(id: id, name: name, species: species, gender: gender, image: image)
        }
    }
}
