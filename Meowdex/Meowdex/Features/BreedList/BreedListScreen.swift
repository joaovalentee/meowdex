//
//  BreedListScreen.swift
//  Meowdex
//
//  Created by Johnnie on 27/06/2025.
//

import SwiftUI
import SwiftData

struct BreedListScreen: View {
	
	@State private var navigation: Navigation = Navigation()
	@State private var viewModel: BreedListViewModel = BreedListViewModel()
	
	private var breeds: [CatBreed] {
		viewModel.breeds
	}
	
	private func ImageShape() -> RoundedRectangle {
		return RoundedRectangle(cornerRadius: 18)
	}
	
    var body: some View {
		NavigationStack(path: $navigation.path) {
			List {
				if viewModel.isLoading {
					LoadingSection()					
				}
				
				Section {
					ForEach(breeds) { breed in
						Button {
							navigation.push(.details(breed))
						} label: {
							HStack(spacing: 16) {
								if let imageUrl = breed.imageUrl {
									AsyncImage(url: URL(string: imageUrl)) { phase in
										if let image = phase.image {
											image
												.resizable()
												.aspectRatio(contentMode: .fill)
												.frame(width: 55, height: 55, alignment: .top)
												.clipShape(ImageShape())
										} else if phase.error != nil {
											ImageShape()
												.fill(.secondary)
												.frame(width: 55, height: 55, alignment: .top)
												.clipShape(ImageShape())
												.overlay {
													Image(systemName: "photo")
												}
										} else {
											ImageShape()
												.fill(.secondary)
												.overlay {
													ProgressView()
														.tint(.primary)
												}
										}
									}
									.frame(width: 55, height: 55)
									
								} else {
									ImageShape()
										.fill(.secondary)
										.frame(width: 55, height: 55, alignment: .top)
										.clipShape(ImageShape())
										.overlay {
											Image(systemName: "photo")
										}
								}
								
								Text(breed.breed)
									.fontWeight(.semibold)
								
								Spacer()
								
								BreedFavoriteButton(isFavourite: viewModel.isFavourite(breed)) {
									viewModel.toggleFavourite(for: breed)
								}
								.font(.title2)
							}
						}
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
}

extension BreedListScreen {
	@ViewBuilder
	private func LoadingSection() -> some View {
		Section {
			ProgressView()
				.tint(.primary)
				.frame(maxWidth: .infinity)
		}
		.listRowBackground(Color.clear)
		.listRowInsets(EdgeInsets())
	}
}

#Preview {
    BreedListScreen()
		.catBreedsDataContainerPreview(populateWith: CatBreed.preview)
}
