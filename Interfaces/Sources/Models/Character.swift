import Foundation

public struct Character: Hashable {
    let id: String
    public let name: String
    public let species: String
    public let gender: Gender
    public let image: String

    public init(id: String, name: String, species: String, gender: Gender, image: String) {
        self.id = id
        self.name = name
        self.species = species
        self.gender = gender
        self.image = image
    }
}
