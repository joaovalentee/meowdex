//
//  BreedListItem.swift
//  Meowdex
//
//  Created by Johnnie on 29/06/2025.
//

import SwiftUI

struct BreedListItem: View {
	
	@Environment(Navigation.self) private var navigation
	
	private let name: String
	private let imageUrl: String?
	private let isFavorite: Bool
	private let toggleFavoritAction: () -> Void
	private let action: () -> Void
	
	init(
		breed: CatBreed,
		isFavorite: Bool,
		toggleFavoritAction: @escaping () -> Void,
		action: @escaping () -> Void
	) {
		self.name = breed.breed
		self.imageUrl = breed.imageUrl
		self.isFavorite = isFavorite
		self.toggleFavoritAction = toggleFavoritAction
		self.action = action
	}
	
	init(
		favoriteBreed: FavouriteBreed,
		toggleFavoritAction: @escaping () -> Void,
		action: @escaping () -> Void
	) {
		self.name = favoriteBreed.breed
		self.imageUrl = nil
		self.isFavorite = true
		self.toggleFavoritAction = toggleFavoritAction
		self.action = action
	}
	
    var body: some View {
		Button {
			action()
		} label: {
			HStack(spacing: 16) {
				if let imageUrl {
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
				
				Text(name)
					.fontWeight(.semibold)
				
				Spacer()
				
				BreedFavoriteButton(isFavourite: isFavorite) {
					toggleFavoritAction()
				}
				.font(.title2)
			}
		}
    }
	
	private func ImageShape() -> RoundedRectangle {
		return RoundedRectangle(cornerRadius: 18)
	}
	
}

#Preview {
	List {
		ForEach(CatBreed.preview) { breed in
			BreedListItem(breed: breed, isFavorite: true, toggleFavoritAction: { } , action:  { })
		}
	}
	
}
