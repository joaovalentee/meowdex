//
//  ContentView.swift
//  Meowdex
//
//  Created by Johnnie on 27/06/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
		BreedListScreen()
    }
}

#Preview {
    ContentView()
		.catBreedsDataContainerPreview(populateWith: CatBreed.preview)
}
