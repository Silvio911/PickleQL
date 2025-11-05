//
//  CharacterListView.swift
//  PickleQL
//
//  Created by Silvio Bulla on 05.11.25.
//

import Interfaces
import Networking
import SwiftUI

struct CharacterListView: View {
    @StateObject var viewModel: CharacterListViewModel

    var body: some View {
        VStack {
            switch viewModel.state {
            case .loading:
                ProgressView()
                    .progressViewStyle(.circular)
                    .tint(.gray)
            case .content(let dictionary):
                let characters = dictionary.values.flatMap { $0 }
                List(characters) { character in
                    NavigationLink {
                        CharacterDetailView(character: character)
                    } label: {
                        HStack(spacing: 16) {
                            AsyncImage(url: URL(string: character.image)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())

                            Text(character.name)
                        }
                    }
                }
            case .empty:
               Text("No data found")
            }
        }
        .navigationTitle("Characters")
        .task {
            viewModel.loadData()
        }
    }
}

#Preview {
    NavigationStack {
        CharacterListView(viewModel: CharacterListViewModel(client: GraphQLClient()))
    }
}
