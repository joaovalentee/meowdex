//
//  TheCatAPIService.swift
//  Meowdex
//
//  Created by Johnnie on 27/06/2025.
//

import Foundation
import OSLog

fileprivate let logger = Logger(subsystem: "Meowdex", category: "TheCatAPIService")

final class TheCatAPIService: CatBreedAPIService {
	
	private let session: URLSession
	
	init(
		session: URLSession = .shared
	){
		self.session = session
	}
	
	func fetchBreeds(
		page: Int,
		limit: Int = 12
	) async throws -> [Breed] {
		guard let request = ApiConstants.buildGetBreedsRequest(page: page, limit: limit) else {
			logger.error("Failed to format URL")
			throw MeowError.networkError(.badURL)
		}
		
		return try await session.get(for: request)
	}
	
	func searchBreeds(
		name: String
	) async throws -> [Breed] {
		guard let request = ApiConstants.buildGetSearchBreedsRequest(name: name) else {
			logger.error("Failed to format URL")
			throw MeowError.networkError(.badURL)
		}
		
		return try await session.get(for: request)
	}
	
	func fetchBreedImage(with id: String) async throws -> ImageResponse {
		guard let request = ApiConstants.buildGetBreedImageRequest(imageId: id) else {
			logger.error("Failed to format URL")
			throw MeowError.networkError(.badURL)
		}
		
		return try await session.get(for: request)
	}
	
	func fetchImage(from urlString: String) async throws -> Data {
		guard let request = ApiConstants.buildGetImageRequest(from: urlString) else {
			logger.error("Failed to format URL")
			throw MeowError.networkError(.badURL)
		}
		
		return try await session.get(for: request)
	}
	
	func fetchFavorites(userId: String) async throws -> [Favorite] {
		guard let request = ApiConstants.buildGetFavoritesRequest(userId: userId) else {
			logger.error("Failed to format URL")
			throw MeowError.networkError(.badURL)
		}
		
		return try await session.get(for: request)
	}
	
	func addFavorite(imageId: String, userId: String) async throws -> Int {
		guard let request = ApiConstants.buildPostFavoriteRequest(imageId: imageId, userId: userId) else {
			logger.error("Failed to format URL")
			throw MeowError.networkError(.badURL)
		}
		
		let favorite: FavoritePOSTResponse = try await session.post(to: request)
		
		return favorite.id
	}
	
	func removeFavorite(favoriteId: Int) async throws {
		guard let request = ApiConstants.buildDeleteFavoriteRequest(favoriteId: favoriteId) else {
			logger.error("Failed to format URL")
			throw MeowError.networkError(.badURL)
		}
		
		let _ : FavoriteDELETEResponse = try await session.delete(for: request)
	}
}
