//
//  CatBreedAPIService.swift
//  Meowdex
//
//  Created by Johnnie on 27/06/2025.
//

import Foundation

protocol CatBreedAPIService {
	func fetchBreeds(
		page: Int,
		limit: Int
	) async throws -> [Breed]
	
	func searchBreeds(
		name: String
	) async throws -> [Breed]
	
	func fetchFavorites(
		userId: String
	) async throws -> [Favorite]
	
	func addFavorite(
		imageId: String,
		userId: String
	) async throws
	
	func removeFavorite(
		favoriteId: Int
	) async throws
}

