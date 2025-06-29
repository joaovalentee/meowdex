//
//  PersistenceServiceProtocol.swift
//  Meowdex
//
//  Created by Johnnie on 29/06/2025.
//

import Foundation

protocol FavoritePersistenceServiceProtocol {
	func loadFavoriteIDs() -> [String:Int]
	func loadFavorites() -> [FavouriteBreed]?
	func saveFavorite(_ favorite: FavouriteBreed)
	func saveFavorites(_ favorites: [FavouriteBreed])
	func removeFavorite(id: Int)
	func clearFavorites()
	func isFavorite(imageId: String) -> Bool
	
	func savePendingAction(_ action: FavoritePendingAction) throws
	func loadPendingActions() throws -> [FavoritePendingAction]?  
	func deletePendingAction(id: String)
	func clearPendingActions()
}
