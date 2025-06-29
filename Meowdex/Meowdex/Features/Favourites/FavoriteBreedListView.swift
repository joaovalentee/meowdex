//
//  FavoriteBreedListView.swift
//  Meowdex
//
//  Created by Johnnie on 29/06/2025.
//

import SwiftUI
import SwiftData

struct FavoriteBreedListView: View {
	@Environment(Navigation.self) private var navigation
	
	@State private var viewModel: FavoriteBreedListViewModel
	
	init(modelContext: ModelContext) {
		_viewModel = State(initialValue: FavoriteBreedListViewModel(modelContext: modelContext))
	}
	
	private var favorites: [FavouriteBreed] {
		viewModel.favorites
	}

	var body: some View {
		List {
			if viewModel.isLoading {
				LoadingSection()
			}
			
			Section {
				ForEach(favorites) { breed in
					BreedListItem(
						favoriteBreed: breed,
						toggleFavoritAction: {
							Task {
//								await viewModel.removeFavorite(breed)
							}
						},
						action: {
//							navigation.push(.details(breed))
						}
					)
				}
			}
		}
		.listSectionSpacing(6)
		.foregroundStyle(.primary)
		.navigationTitle("Favorites")
		.navigationDestination(for: NavigationOptions.self) { page in
			page.viewForPage()
		}
		.refreshable {
//			await viewModel.refreshBreeds()
		}
	}
}

#Preview {
	FavoriteBreedListScreen()
		.catBreedsDataContainerPreview(populateWith: CatBreed.preview)
}
