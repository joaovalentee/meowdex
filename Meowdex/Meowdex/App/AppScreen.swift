//
//  AppScreen.swift
//  Meowdex
//
//  Created by Johnnie on 29/06/2025.
//

import SwiftUI

enum AppScreen : Identifiable, CaseIterable {
	case list
	case favorites
	
	var id: AppScreen { self }
}

extension AppScreen {
	@ViewBuilder
	var label: some View {
		switch self {
			case .list:
				Label("Breeds", systemImage: "cat.fill")
			case .favorites:
				Label("Favorites", systemImage: "heart.fill")
		}
	}
	
	@MainActor
	@ViewBuilder
	func destination() -> some View {
		switch self {
			case .list:
				BreedListScreen()
			case .favorites:
				FavoriteBreedListScreen()
		}
	}
}
