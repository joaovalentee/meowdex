//
//  BreedListVIew.swift
//  Meowdex
//
//  Created by Johnnie on 29/06/2025.
//

import SwiftUI
import SwiftData

struct BreedListView: View {
	
	@Environment(Navigation<CatBreedNavigationOptions>.self) private var navigation
	
	@State private var viewModel: BreedListViewModel
	@FocusState private var isSearching: Bool
	
	init(store: CatBreedStore) {
		_viewModel = State(initialValue: BreedListViewModel(store: store))
	}
	
	private var breeds: [CatBreed] {
		viewModel.breeds
	}
	
	private func ImageShape() -> RoundedRectangle {
		return RoundedRectangle(cornerRadius: 18)
	}
	
    var body: some View {
		Group {
			if isSearching {
				List {
					BreedListSection(sectionName: "search results", viewModel.filteredBreeds, isLoading: viewModel.isLoadingSearch)
				}
			} else {
				BreedList()
			}
		}
		.foregroundStyle(.primary)
		.navigationTitle("Cat Breeds")
		.searchable(text: $viewModel.searchQuery, placement: .navigationBarDrawer, prompt: "Search cat breeds")
		.searchFocused($isSearching)
		.onChange(of: isSearching) { oldValue, newValue in
			if !newValue {
				viewModel.clearSearch()
			}
		}
    }
}

extension BreedListView {
	@ViewBuilder
	private func BreedList() -> some View {
		List {
			BreedListSection(breeds, isLoading: viewModel.isLoading)
			
			if viewModel.isLoadingMore {
				LoadingSection()
			}
		}
		.listSectionSpacing(6)
		.refreshable {
			await viewModel.refreshBreeds()
		}
	}
	
	@ViewBuilder
	private func BreedListSection(
		sectionName: String? = nil,
		_ breeds: [CatBreed],
		isLoading: Bool
	) -> some View {
		Section {
			if isLoading {
				LoadingSection()
			}
			
			ForEach(breeds) { breed in
				BreedListItem(
					breed: breed,
					isFavorite: viewModel.isFavourite(breed),
					toggleFavoritAction: {
						await viewModel.toggleFavorite(for: breed)
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
		} header: {
			if let sectionName {
				Text(sectionName)
			}
		}
	}
}

#Preview {
	BreedListScreen()
		.catBreedsDataContainerPreview(populateWith: CatBreed.preview)
}
