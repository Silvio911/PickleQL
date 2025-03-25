// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class CharactersQuery: GraphQLQuery {
  public static let operationName: String = "Characters"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query Characters($page: Int) { characters(page: $page) { __typename info { __typename count pages next } results { __typename id name species gender image } } }"#
    ))

  public var page: GraphQLNullable<Int>

  public init(page: GraphQLNullable<Int>) {
    self.page = page
  }

  public var __variables: Variables? { ["page": page] }

  public struct Data: PickleAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { PickleAPI.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("characters", Characters?.self, arguments: ["page": .variable("page")]),
    ] }

    /// Get the list of all characters
    public var characters: Characters? { __data["characters"] }

    /// Characters
    ///
    /// Parent Type: `Characters`
    public struct Characters: PickleAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { PickleAPI.Objects.Characters }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("info", Info?.self),
        .field("results", [Result?]?.self),
      ] }

      public var info: Info? { __data["info"] }
      public var results: [Result?]? { __data["results"] }

      /// Characters.Info
      ///
      /// Parent Type: `Info`
      public struct Info: PickleAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { PickleAPI.Objects.Info }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("count", Int?.self),
          .field("pages", Int?.self),
          .field("next", Int?.self),
        ] }

        /// The length of the response.
        public var count: Int? { __data["count"] }
        /// The amount of pages.
        public var pages: Int? { __data["pages"] }
        /// Number of the next page (if it exists)
        public var next: Int? { __data["next"] }
      }

      /// Characters.Result
      ///
      /// Parent Type: `Character`
      public struct Result: PickleAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { PickleAPI.Objects.Character }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", PickleAPI.ID?.self),
          .field("name", String?.self),
          .field("species", String?.self),
          .field("gender", String?.self),
          .field("image", String?.self),
        ] }

        /// The id of the character.
        public var id: PickleAPI.ID? { __data["id"] }
        /// The name of the character.
        public var name: String? { __data["name"] }
        /// The species of the character.
        public var species: String? { __data["species"] }
        /// The gender of the character ('Female', 'Male', 'Genderless' or 'unknown').
        public var gender: String? { __data["gender"] }
        /// Link to the character's image.
        /// All images are 300x300px and most are medium shots or portraits since they are intended to be used as avatars.
        public var image: String? { __data["image"] }
      }
    }
  }
}
