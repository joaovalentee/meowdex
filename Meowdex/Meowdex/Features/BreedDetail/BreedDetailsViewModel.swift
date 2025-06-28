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
	
	// MARK: - Dependencies
	private let apiService: CatBreedAPIService
	//private let persistenceService: PersistenceServiceProtocol
	
	// MARK: - Init
	init(
		breed: CatBreed,
		apiService: CatBreedAPIService = TheCatAPIService()
		//persistenceService: PersistenceServiceProtocol = PersistenceService()
	) {
		self.breed = breed
		self.apiService = apiService
		//self.persistenceService = persistenceService
		
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
	
	func isFavorite(_ breed: CatBreed) -> Bool {
//		favouriteIDs.contains(breed.id)
		false
	}
	
	// MARK: - Private Methods
	
}
