//
//  CharacterDetailView.swift
//  PickleQL
//
//  Created by Silvio Bulla on 05.11.25.
//

import SwiftUI
import Interfaces

struct CharacterDetailView: View {
    let character: Character
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                AsyncImage(url: URL(string: character.image)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 200, height: 200)
                .clipShape(Circle())
                
                Text(character.name)
                    .font(.title)
                    .bold()
                
                VStack(alignment: .leading, spacing: 10) {
                    DetailRow(title: "Species", value: character.species)
                    DetailRow(title: "Gender", value: character.gender.rawValue.capitalized)
                }
                .padding()
                
                Spacer()
            }
            .navigationTitle("Character Details")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
            Spacer()
            Text(value)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    CharacterDetailView(
        character: Character(
            id: "1",
            name: "Rick Sanchez",
            species: "Human",
            gender: .male,
            image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg"
        )
    )
}
