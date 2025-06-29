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
	
	func fetchBreedImage(
		with id: String
	) async throws -> ImageResponse
	
	func fetchImage(
		from urlString: String
	) async throws -> Data
	
	func fetchFavorites(
		userId: String
	) async throws -> [Favorite]
	
	func addFavorite(
		imageId: String,
		userId: String
	) async throws -> Int
	
	func removeFavorite(
		favoriteId: Int
	) async throws
}

