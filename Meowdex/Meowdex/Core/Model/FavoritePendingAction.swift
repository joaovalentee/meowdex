//
//  FavoritePendingAction.swift
//  Meowdex
//
//  Created by Johnnie on 29/06/2025.
//

import Foundation
import SwiftData

@Model
final class FavoritePendingAction {
	@Attribute(.unique)
	var id: String
	var breedId: String
	var action: FavoriteActionType
	var timestamp: Date
	
	init(
		breedId: String,
		action: FavoriteActionType,
		timestamp: Date = .now
	) {
		self.id = breedId
		self.breedId = breedId
		self.action = action
		self.timestamp = timestamp
	}
}

enum FavoriteActionType: Codable {
	case markFavorite(String)
	case unmarkFavorite(Int)
}
