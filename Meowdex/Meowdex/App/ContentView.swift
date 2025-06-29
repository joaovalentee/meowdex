//
//  ContentView.swift
//  Meowdex
//
//  Created by Johnnie on 27/06/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
	@Environment(\.modelContext) private var modelContext
	
    var body: some View {
		CatBreedTabView(modelContext: modelContext)
    }
}

#Preview {
    ContentView()
		.catBreedsDataContainerPreview(populateWith: CatBreed.preview)
}
