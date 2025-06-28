//
//  BreedDetailsScreen.swift
//  Meowdex
//
//  Created by Johnnie on 28/06/2025.
//

import SwiftUI

struct BreedDetailsScreen: View {
	
	@State private var viewModel: BreedDetailsViewModel
	
	init(breed: CatBreed) {
		_viewModel = State(initialValue: BreedDetailsViewModel(breed: breed))
	}
	
	private var breed : CatBreed {
		viewModel.breed
	}
	
    var body: some View {
		List {
			Section {
				Image("cat")
					.resizable()
					.aspectRatio(contentMode: .fill)
					.frame(height: 200, alignment: .top)
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
				BreedFavoriteButton(isFavourite: false) {
//					viewModel.toggleFavourite(for: breed)
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
