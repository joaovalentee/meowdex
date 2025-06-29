//
//  BreedListScreen.swift
//  Meowdex
//
//  Created by Johnnie on 27/06/2025.
//

import SwiftUI
import SwiftData

struct BreedListScreen: View {
	@EnvironmentObject private var store: CatBreedStore
	
	@State private var navigation: Navigation<CatBreedNavigationOptions> = Navigation()
	
    var body: some View {
		NavigationStack(path: $navigation.path) {
			BreedListView(store: store)
				.environment(navigation)
				.navigationDestination(for: CatBreedNavigationOptions.self) { page in
					page.viewForPage()
				}
		}
    }
}

#Preview {
    BreedListScreen()
		.catBreedsDataContainerPreview(populateWith: CatBreed.preview)
}
