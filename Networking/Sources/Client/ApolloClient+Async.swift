import Apollo
import Foundation
import PickleAPI

extension ApolloClient {
    /// Executes a GraphQL query asynchronously using `async/await` instead of a completion handler.
    ///
    /// This method wraps Apollo’s `fetch(query:completionHandler:)` in `withCheckedThrowingContinuation`
    /// to provide a seamless `async` experience.
    ///
    /// - Parameter query: A `GraphQLQuery` that defines the request.
    /// - Returns: The `GraphQLResult` containing the query's response data.
    /// - Throws: An error if the request fails.
    func execute<Query: GraphQLQuery>(_ query: Query) async throws -> GraphQLResult<Query.Data> {
        try await withCheckedThrowingContinuation { continuation in
            fetch(query: query) { result in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
