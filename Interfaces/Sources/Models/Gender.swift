//
//  Gender.swift
//  Interfaces
//
//  Created by Silvio Bulla on 26.03.25.
//

public enum Gender: String {
    case female = "Female"
    case male = "Male"
    case genderless = "Genderless"
    case unknown

    public init(_ rawValue: String) {
        self = Gender(rawValue: rawValue) ?? .unknown
    }
}

extension Gender {
    public var emoji: String {
         switch self {
         case .female:
             return "♀"
         case .male:
             return "⚦"
         case .genderless:
             return "▵"
         case .unknown:
             return "𖤊"
         }
     }
}
