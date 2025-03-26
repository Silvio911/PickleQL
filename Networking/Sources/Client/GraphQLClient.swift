import Foundation
import Apollo
import PickleAPI

final class GraphQLClient {
    /// The Apollo client that is used to perform the network requests.
    private let apolloClient: ApolloClient

    // https://rickandmortyapi.com/graphql

    init(url: URL) {
        self.apolloClient = ApolloClient(url: url)
    }
}
