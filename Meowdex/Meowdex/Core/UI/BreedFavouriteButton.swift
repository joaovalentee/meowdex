//
//  BreedFavouriteButton.swift
//  Meowdex
//
//  Created by Johnnie on 27/06/2025.
//

import SwiftUI

struct BreedFavoriteButton: View {
	private let isFavourite: Bool
	private let onClick: () async -> Void
	
	@State private var isLoading: Bool = false
	@State private var task: Task<Void, Never>?
	
	init(
		isFavourite: Bool,
		onClick: @escaping () async -> Void
	) {
		self.isFavourite = isFavourite
		self.onClick = onClick
	}
	
	var body: some View {
		Button {
			if isLoading {
				task?.cancel()
				return
			}
			task = Task {
				isLoading = true
				await onClick()
				isLoading = false
			}
		} label: {
			if isLoading {
				ProgressView()
			} else {
				FavoriteButtonLabel(isFavourite: isFavourite)
			}
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
	BreedFavoriteButton(isFavourite: true) {
		
	}
}
