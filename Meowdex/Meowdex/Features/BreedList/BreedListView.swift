//
//  BreedListVIew.swift
//  Meowdex
//
//  Created by Johnnie on 29/06/2025.
//

import SwiftUI
import SwiftData

struct BreedListView: View {
	
	@Environment(Navigation.self) private var navigation
	
	@State private var viewModel: BreedListViewModel
	
	init(modelContext: ModelContext) {
		_viewModel = State(initialValue: BreedListViewModel(modelContext: modelContext))
	}
	
	private var breeds: [CatBreed] {
		viewModel.breeds
	}
	
	private func ImageShape() -> RoundedRectangle {
		return RoundedRectangle(cornerRadius: 18)
	}
	
    var body: some View {
		List {
			if viewModel.isLoading {
				LoadingSection()
			}
			
			Section {
				ForEach(breeds) { breed in
					BreedListItem(
						breed: breed,
						isFavorite: viewModel.isFavourite(breed),
						toggleFavoritAction: {
							Task {
								await viewModel.toggleFavourite(for: breed)
							}
						},
						action: {
							navigation.push(.details(breed))
						}
					)
					.task {
						if let index = breeds.firstIndex(of: breed),
						   index == breeds.count - 5 {
							print("Item \(index) appeared — loading next page")
							await viewModel.loadNextPage()
						}
					}
				}
			}
			
			if viewModel.isLoadingMore {
				LoadingSection()
			}
		}
		.listSectionSpacing(6)
		.foregroundStyle(.primary)
		.navigationTitle("Cat Breeds")
		.navigationDestination(for: NavigationOptions.self) { page in
			page.viewForPage()
		}
		.refreshable {
			await viewModel.refreshBreeds()
		}
    }
}

#Preview {
	BreedListScreen()
		.catBreedsDataContainerPreview(populateWith: CatBreed.preview)
}
