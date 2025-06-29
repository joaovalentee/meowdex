//
//  FavoritesNavigationOptions.swift
//  Meowdex
//
//  Created by Johnnie on 29/06/2025.
//


import SwiftUI

enum FavoriteNavigationOptions: Hashable {
	case details(FavouriteBreed)
	
	@ViewBuilder
	func viewForPage() -> some View {
		switch self {
			case .details(let breed):
				FavoriteDetailsScreen(favorite: breed)
		}
	}
}
