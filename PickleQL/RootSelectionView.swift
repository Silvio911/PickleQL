//
//  SelectionView.swift
//  PickleQL
//
//  Created by Silvio Bulla on 05.11.25.
//

import SwiftUI
import UIKit

enum ImplementationType {
    case uikit
    case swiftui
}

struct RootSelectionView: View {
    var onSelection: (ImplementationType) -> Void
    
    var body: some View {
        List {
            Section {
                Button {
                    onSelection(.uikit)
                } label: {
                    HStack {
                        Image(systemName: "iphone.gen3")
                            .font(.title2)
                            .foregroundStyle(.blue)
                            .frame(width: 40)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("UIKit Implementation")
                                .font(.headline)
                            Text("Traditional UIKit with UICollectionView")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.secondary)
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                
                Button {
                    onSelection(.swiftui)
                } label: {
                    HStack {
                        Image(systemName: "swift")
                            .font(.title2)
                            .foregroundStyle(.orange)
                            .frame(width: 40)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("SwiftUI Implementation")
                                .font(.headline)
                            Text("Modern SwiftUI with declarative syntax")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.secondary)
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            } header: {
                Text("Choose Implementation")
            } footer: {
                Text("Select which implementation you'd like to view. Both show the same data with different UI frameworks.")
            }
        }
        .navigationTitle("PickleQL")
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    NavigationStack {
        RootSelectionView { type in
            print("Selected: \(type)")
        }
    }
}
