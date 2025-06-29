//
//  PersistenceServiceProtocol.swift
//  Meowdex
//
//  Created by Johnnie on 29/06/2025.
//

import Foundation

protocol FavoritePersistenceServiceProtocol {
	func loadFavoriteIDs() async -> [String:Int]
	func saveFavorite(_ favorite: FavouriteBreed)
	func removeFavorite(id: Int)
}
