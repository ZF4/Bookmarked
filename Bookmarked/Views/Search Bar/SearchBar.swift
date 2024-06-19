//
//  SearchBar.swift
//  Bookmarked
//
//  Created by Zachary Farmer on 6/5/24.
//

import SwiftUI

struct SearchBar: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var searchText: String
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(Color.gray)
            
            TextField("Search your books", text: $searchText)
                .foregroundStyle(Color("altButtonTextColor"))
                .overlay(
                    Image(systemName: "xmark.circle.fill")
                        .padding()
                        .offset(x: 10)
                        .foregroundStyle(Color.gray)
                        .opacity(searchText.isEmpty ? 0.0 : 1.0)
                        .onTapGesture {
                            searchText = ""
                        }
                    ,alignment: .trailing
                )
        }
        .font(.headline)
        .padding(5)
        .background {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color("addBackgroundColor").opacity(0.5))
                .shadow(
                    color: .black.opacity(0.2),
                    radius: 5
                )
        }
        .padding()
    }
}

#Preview {
    SearchBar(searchText: .constant("test"))
}
