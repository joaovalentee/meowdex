//
//  BreedListViewModel.swift
//  Meowdex
//
//  Created by Johnnie on 28/06/2025.
//

import Foundation
import SwiftData
import Observation

@Observable
@MainActor
class BreedListViewModel {
	
	// MARK: - Public Properties
	private(set) var breeds: [CatBreed] = []
	private(set) var hasLoadedAllBreeds: Bool = false
	private(set) var filteredBreeds: [CatBreed] = []
	private(set) var searchQuery: String = "" {
		didSet {
			filterBreeds()
		}
	}
	private(set) var isLoading: Bool = true
	private(set) var isLoadingMore: Bool = false
	private(set) var errorMessage: String? = nil
	private(set) var favouriteIDs: [String:Int] = [:]
	
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
			await loadBreeds()
		}
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
	
	// MARK: - Public Methods
	func loadBreeds() async {
		print("loading breeds")
		hasLoadedAllBreeds = false
		isLoading = true
		errorMessage = nil
		
		do {
			let breeds = try await apiService.fetchBreeds(page: 0, limit: ApiConstants.breedsPageLimit).compactMap { CatBreed(from: $0) }
			self.breeds = breeds
			self.filteredBreeds = breeds
		} catch {
			errorMessage = error.localizedDescription
		}
		isLoading = false
	}
	
	func refreshBreeds() async {
		print("refreshing breeds")
		do {
			let breeds = try await apiService.fetchBreeds(page: 0, limit: ApiConstants.breedsPageLimit).compactMap { CatBreed(from: $0) }
			self.breeds = breeds
			self.filteredBreeds = breeds
		} catch {
			errorMessage = error.localizedDescription
		}
	}
	
	func loadNextPage() async {
		guard !hasLoadedAllBreeds,
			  ApiConstants.breedsPageLimit > 0 else {
			return
		}
		
		let nextPage = Int(ceil(Double(breeds.count) / Double(ApiConstants.breedsPageLimit)))

		print("Loading page \(nextPage)")
		
		isLoadingMore = true
		
		do {
			let breeds = try await apiService.fetchBreeds(page: nextPage, limit: ApiConstants.breedsPageLimit)
			
			if breeds.count < ApiConstants.breedsPageLimit {
				hasLoadedAllBreeds = true
			}
			
			
			self.breeds.append(contentsOf: breeds.compactMap { CatBreed(from: $0) })
		} catch {
			
		}
		
		isLoadingMore = false
	}
	
	func toggleFavourite(for breed: CatBreed) async {
		if let imageId = breed.imageId {
			if let favouriteId = favouriteIDs[breed.id] {
				do {
					try await apiService.removeFavorite(favoriteId: favouriteId)
					favouriteIDs.removeValue(forKey: breed.id)
					favoritePersistenceService.removeFavorite(id: favouriteId)
				} catch {
					
				}
			} else {
				do {
					let id = try await apiService.addFavorite(imageId: imageId, userId: userId)
					favouriteIDs[breed.id] = id
					favoritePersistenceService.saveFavorite(FavouriteBreed(favoriteId: id, with: breed))
				} catch {
					
				}
			}
		}
	}
	
	func isFavourite(_ breed: CatBreed) -> Bool {
		favouriteIDs.keys.contains(breed.id)
	}
	
	// MARK: - Private Methods
	func filterBreeds() {
		
	}
	
	func loadFavorites() async {
		self.favouriteIDs = await favoritePersistenceService.loadFavoriteIDs()
	}
}
