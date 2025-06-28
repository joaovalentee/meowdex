//
//  BreedFavouriteButton.swift
//  Meowdex
//
//  Created by Johnnie on 27/06/2025.
//

import SwiftUI

struct BreedFavoriteButton: View {
	private let isFavourite: Bool
	private let onClick: () -> Void
	
	init(breed: CatBreed) {
		isFavourite = false
		self.onClick = { }
	}
	
	init(favourite: FavouriteBreed) {
		isFavourite = true
		self.onClick = { }
	}
	
	init(
		isFavourite: Bool,
		onClick: @escaping () -> Void
	) {
		self.isFavourite = isFavourite
		self.onClick = onClick
	}
	
	var body: some View {
		Button {
			onClick()
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
