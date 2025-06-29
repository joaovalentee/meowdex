//
//  FavoriteBreedListScreen.swift
//  Meowdex
//
//  Created by Johnnie on 29/06/2025.
//

import SwiftUI

struct FavoriteBreedListScreen: View {
	@EnvironmentObject private var store: CatBreedStore
	
	@State private var navigation: Navigation<FavoriteNavigationOptions> = Navigation()
	
	var body: some View {
		NavigationStack(path: $navigation.path) {
			FavoriteBreedListView(store: store)
				.environment(navigation)
				.navigationDestination(for: FavoriteNavigationOptions.self) { page in
					page.viewForPage()
				}
		}
	}
}

#Preview {
    FavoriteBreedListScreen()
		.catBreedsDataContainerPreview(populateWith: CatBreed.preview)
}
