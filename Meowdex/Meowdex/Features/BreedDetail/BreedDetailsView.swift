//
//  BreedDetailsView.swift
//  Meowdex
//
//  Created by Johnnie on 29/06/2025.
//

import SwiftUI
import SwiftData

struct BreedDetailsView: View {
	
	@State private var viewModel: BreedDetailsViewModel
	
	init(
		breed: CatBreed,
		context: ModelContext
	) {
		_viewModel = State(
			initialValue: BreedDetailsViewModel(
				breed: breed,
				favoritePersistenceService: FavoritePersistenceService(context: context)
			)
		)
	}
	
	private var breed : CatBreed {
		viewModel.breed
	}
	
    var body: some View {
		List {
			Section {
				BreedImage(imageUrl: breed.imageUrl)
					.frame(height: 400, alignment: .top)
					.listRowInsets(EdgeInsets())
			}
			
			Section("Origin") {
				Text(breed.origin)
					.textSelection(.enabled)
			}
			
			Section("Temperament") {
				ForEach(breed.temperament) { temperament in
					Text(temperament.name)
						.textSelection(.enabled)
				}
			}
			
			Section("Description") {
				Text(breed.details)
					.textSelection(.enabled)
			}
		}
		.navigationTitle(breed.breed)
		.toolbar {
			ToolbarItem(placement: .topBarTrailing) {
				BreedFavoriteButton(isFavourite: viewModel.isFavorite) {
					viewModel.toggleFavourite(for: breed)
				}
				.font(.title2)
			}
			.foregroundStyle(.red)
		}
    }
}

#Preview {
	NavigationStack {
		BreedDetailsScreen(breed: CatBreed.preview.first!)
	}
}
