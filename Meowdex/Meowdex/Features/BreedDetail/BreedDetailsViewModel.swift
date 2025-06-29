//
//  BreedDetailsViewModel.swift
//  Meowdex
//
//  Created by Johnnie on 28/06/2025.
//

import Foundation
import Observation

@Observable
@MainActor
class BreedDetailsViewModel {
	
	// MARK: - Public Properties
	private(set) var breed: CatBreed
	private(set) var isFavorite: Bool
	
	// MARK: - Dependencies
	private let apiService: CatBreedAPIService
	private let favoritePersistenceService: FavoritePersistenceServiceProtocol
	
	// MARK: - Init
	init(
		breed: CatBreed,
		apiService: CatBreedAPIService = TheCatAPIService(),
		favoritePersistenceService: FavoritePersistenceServiceProtocol
	) {
		self.breed = breed
		self.apiService = apiService
		self.favoritePersistenceService = favoritePersistenceService
		if let imageId = breed.imageId {
			self.isFavorite = favoritePersistenceService.isFavorite(imageId: imageId)
		} else {
			self.isFavorite = false
		}
	}
	
	// MARK: - Public Methods
	
	func toggleFavourite(for breed: CatBreed) {
//		if favouriteIDs.contains(breed.id) {
//			favouriteIDs.remove(breed.id)
//			//			persistenceService.removeFavourite(id: breed.id)
//		} else {
//			favouriteIDs.insert(breed.id)
//			//			persistenceService.saveFavourite(id: breed.id)
//		}
	}
	
	// MARK: - Private Methods
	
}
