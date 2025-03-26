import Foundation

public struct Character {
    let id: String
    let name: String
    let species: String
    let gender: String
    let image: String

    public init(id: String, name: String, species: String, gender: String, image: String) {
        self.id = id
        self.name = name
        self.species = species
        self.gender = gender
        self.image = image
    }
}
