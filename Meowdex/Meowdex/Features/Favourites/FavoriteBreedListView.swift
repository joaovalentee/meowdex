//
//  FavoriteBreedListView.swift
//  Meowdex
//
//  Created by Johnnie on 29/06/2025.
//

import SwiftUI
import SwiftData

struct FavoriteBreedListView: View {
	@Environment(Navigation<FavoriteNavigationOptions>.self) private var navigation
	
	@State private var viewModel: FavoriteBreedListViewModel
	
	init(store: CatBreedStore) {
		_viewModel = State(initialValue: FavoriteBreedListViewModel(store: store))
	}

	var body: some View {
		List {
			if viewModel.isLoading {
				LoadingSection()
			}
			
			if !viewModel.favorites.isEmpty {
				if let averageLifespan = viewModel.averageLifespan {
					Section {
						VStack {
							Text("\(averageLifespan)")
								.font(.title)
								.fontWeight(.bold)
							Text("average lifespan (years)")
								.font(.caption)
								.textCase(.uppercase)
								.foregroundStyle(.secondary)
						}
						.frame(maxWidth: .infinity)
					}
					.listRowBackground(Color.clear)
					.listRowInsets(EdgeInsets())
				}
				
				Section {
					ForEach(viewModel.favorites) { breed in
						BreedListItem(
							favoriteBreed: breed,
							toggleFavoritAction: {
								await viewModel.removeFavorite(id: breed.id, imageId: breed.imageId)
							},
							action: {
								navigation.push(.details(breed))
							}
						)
					}
				}
			} else if !viewModel.isLoading {
				Section {
					Text("No favorites yet")
						.font(.title3)
						.fontWeight(.semibold)
						.frame(maxWidth: .infinity)
				}
				.listRowBackground(Color.clear)
			}
		}
		.foregroundStyle(.primary)
		.navigationTitle("Favorites")
		.refreshable {
			await viewModel.refreshFavorites()
		}
		.alert("Error", isPresented: viewModel.hasError) {
			Button("OK", role: .cancel) {
				viewModel.errorMessage = nil
			}
		} message: {
			Text(viewModel.errorMessage ?? "Something went wrong")
		}
		.onAppear {
			Task {
				await viewModel.syncPendingActions()
			}
		}
	}
}

#Preview {
	FavoriteBreedListScreen()
		.catBreedsDataContainerPreview(populateWith: CatBreed.preview)
}
