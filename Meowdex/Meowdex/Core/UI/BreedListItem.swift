//
//  BreedListItem.swift
//  Meowdex
//
//  Created by Johnnie on 29/06/2025.
//

import SwiftUI

struct BreedListItem: View {
	
	private let name: String
	private let imageUrl: String?
	private let isFavorite: Bool
	private let toggleFavoritAction: () async -> Void
	private let action: () -> Void
	
	init(
		breed: CatBreed,
		isFavorite: Bool,
		toggleFavoritAction: @escaping () async -> Void,
		action: @escaping () -> Void
	) {
		if let imageUrl = breed.imageUrl {
			self.imageUrl = imageUrl
		} else {
			self.imageUrl = nil
		}
		self.name = breed.breed
		self.isFavorite = isFavorite
		self.toggleFavoritAction = toggleFavoritAction
		self.action = action
	}
	
	init(
		favoriteBreed: FavouriteBreed,
		toggleFavoritAction: @escaping () async -> Void,
		action: @escaping () -> Void
	) {
		self.name = favoriteBreed.breed
		self.imageUrl = favoriteBreed.imageUrl
		self.isFavorite = true
		self.toggleFavoritAction = toggleFavoritAction
		self.action = action
	}
	
    var body: some View {
		Button {
			action()
		} label: {
			HStack(spacing: 16) {
				BreedImage(imageUrl: imageUrl)
					.frame(width: 55, height: 55, alignment: .top)
					.clipShape(RoundedRectangle.imageShape)
				
				Text(name)
					.fontWeight(.semibold)
				
				Spacer()
				
				BreedFavoriteButton(isFavourite: isFavorite) {
					await toggleFavoritAction()
				}
				.font(.title2)
			}
		}
    }
}

#Preview {
	List {
		ForEach(CatBreed.preview) { breed in
			BreedListItem(breed: breed, isFavorite: true, toggleFavoritAction: { } , action:  { })
		}
	}
	
}
