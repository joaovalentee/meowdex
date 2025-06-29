//
//  FavoritePendingAction.swift
//  Meowdex
//
//  Created by Johnnie on 29/06/2025.
//

import Foundation
import SwiftData

@Model
final class FavoritePendingAction: Identifiable {
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

extension FavoritePendingAction : CustomStringConvertible {
	var description: String {
		"\(id) \(breedId) \(action.id) \(timestamp)"
	}
}

enum FavoriteActionType: Identifiable, Codable {
	case markFavorite(String)
	case unmarkFavorite(Int)
	
	var id: String {
		switch self {
			case .markFavorite(let breeId):
				return "markFavorite(\(breeId))"
			case .unmarkFavorite(let id):
				return "unmarkFavorite(\(id))"
		}
	}
}
