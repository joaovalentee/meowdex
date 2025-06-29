//
//  FavoriteBreedListViewModel.swift
//  Meowdex
//
//  Created by Johnnie on 29/06/2025.
//

import Foundation
import Observation
import SwiftData

class FavoriteBreedListViewModel {
	
	private(set) var favorites: [FavouriteBreed] = []
	private(set) var isLoading: Bool = true
	private(set) var errorMessage: String? = nil
	
	private var userId: String = "aabbccdd"
	
	// MARK: - Dependencies
	private let apiService: CatBreedAPIService
	private let favoritePersistenceService: FavoritePersistenceServiceProtocol
	
	// MARK: - Init
	init(
		apiService: CatBreedAPIService = TheCatAPIService(),
		favoritePersistenceService: FavoritePersistenceServiceProtocol
	) {
		self.apiService = apiService
		self.favoritePersistenceService = favoritePersistenceService
		Task {
			await loadFavorites()
		}
	}
	
	convenience init(
		apiService: CatBreedAPIService = TheCatAPIService(),
		modelContext: ModelContext
	) {
		self.init(
			apiService: apiService,
			favoritePersistenceService: FavoritePersistenceService(context: modelContext)
		)
	}
	
	func removeFavorite() async {
		
	}
	
	// MARK: - Private methods
	private func loadFavorites() async {
		print("loading breeds")
		isLoading = true
		errorMessage = nil
		
//		do {
//			let breeds = try await apiService.fetchFavorites(userId: userId).compactMap { FavouriteBreed(from: $0) }
//			self.favorites = breeds
//			self.filteredBreeds = breeds
//		} catch {
//			errorMessage = error.localizedDescription
//		}
		
		isLoading = false
	}
}
