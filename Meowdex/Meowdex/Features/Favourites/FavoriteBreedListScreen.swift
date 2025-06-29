//
//  FavoriteBreedListScreen.swift
//  Meowdex
//
//  Created by Johnnie on 29/06/2025.
//

import SwiftUI

struct FavoriteBreedListScreen: View {
	@Environment(\.modelContext) private var modelContext
	
	@State private var navigation: Navigation = Navigation()
	
	var body: some View {
		NavigationStack(path: $navigation.path) {
			FavoriteBreedListView(modelContext: modelContext)
				.environment(navigation)
		}
	}
}

#Preview {
    FavoriteBreedListScreen()
		.catBreedsDataContainerPreview(populateWith: CatBreed.preview)
}
