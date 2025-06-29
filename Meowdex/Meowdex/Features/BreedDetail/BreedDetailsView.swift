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
		store: CatBreedStore
	) {
		_viewModel = State(
			initialValue: BreedDetailsViewModel(
				breed: breed,
				store: store
			)
		)
	}
	
	init(
		favorite: FavouriteBreed,
		store: CatBreedStore
	) {
		_viewModel = State(
			initialValue: BreedDetailsViewModel(
				favorite: favorite,
				store: store
			)
		)
	}
	
    var body: some View {
		List {
			Section {
				BreedImage(imageUrl: viewModel.imageUrl)
					.frame(height: 400, alignment: .top)
					.listRowInsets(EdgeInsets())
			}
			
			Section("Origin") {
				Text(viewModel.origin)
					.textSelection(.enabled)
			}
			
			Section("Temperament") {
				ForEach(viewModel.temperament) { temperament in
					Text(temperament.name)
						.textSelection(.enabled)
				}
			}
			
			Section("Description") {
				Text(viewModel.description)
					.textSelection(.enabled)
			}
		}
		.navigationTitle(viewModel.name)
		.toolbar {
			ToolbarItem(placement: .destructiveAction) {
				BreedFavoriteButton(isFavourite: viewModel.isFavorite) {
					await viewModel.toggleFavorite()
				}
				.font(.title2)
			}
		}
    }
}

#Preview {
	NavigationStack {
		BreedDetailsScreen(breed: CatBreed.preview.first!)
	}
}
