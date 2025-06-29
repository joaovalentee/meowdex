//
//  BreedListScreen.swift
//  Meowdex
//
//  Created by Johnnie on 27/06/2025.
//

import SwiftUI
import SwiftData

struct BreedListScreen: View {
	@Environment(\.modelContext) private var modelContext
	
	@State private var navigation: Navigation = Navigation()
	
    var body: some View {
		NavigationStack(path: $navigation.path) {
			BreedListView(modelContext: modelContext)
				.environment(navigation)
		}
    }
}

#Preview {
    BreedListScreen()
		.catBreedsDataContainerPreview(populateWith: CatBreed.preview)
}
