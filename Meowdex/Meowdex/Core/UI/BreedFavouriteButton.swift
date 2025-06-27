//
//  BreedFavouriteButton.swift
//  Meowdex
//
//  Created by Johnnie on 27/06/2025.
//

import SwiftUI

struct BreedFavoriteButton: View {
	private let isFavourite: Bool
	
	init(breed: CatBreed) {
		isFavourite = false
	}
	
	init(favourite: FavouriteBreed) {
		isFavourite = true
	}
	
	var body: some View {
		Button {
			
		} label: {
			FavoriteButtonLabel(isFavourite: isFavourite)
		}
	}
}


private struct FavoriteButtonLabel: View {
	
	var isFavourite: Bool
	
	var body: some View {
		Label(isFavourite ? "Unfavorite" : "Favorite", systemImage: "heart")
			.symbolVariant(isFavourite ? .fill : .none)
			.labelStyle(.iconOnly)
			.foregroundStyle(.red)
	}
}

#Preview {
	BreedFavoriteButton(breed: CatBreed.preview.first!)
}
