//
//  CatBreedStore.swift
//  Meowdex
//
//  Created by Johnnie on 29/06/2025.
//

import Foundation

@MainActor
class CatBreedStore: ObservableObject {
	
	// MARK: - Public
	@Published var breeds: [CatBreed] = []
	private(set) var hasLoadedAllBreeds: Bool = false
	@Published var favorites: [FavouriteBreed] = []
	
	// MARK: - Private
	private let user: User
	
	// MARK: - Dependencies
	private let apiService: CatBreedAPIService
	private let breedPersistenceService: BreedPersistanceServiceProtocol
	private let favoritePersistenceService: FavoritePersistenceServiceProtocol
	
	// MARK: - Init
	init(
		user: User,
		apiService: CatBreedAPIService,
		breedPersistenceService: BreedPersistanceServiceProtocol,
		favoritePersistenceService: FavoritePersistenceServiceProtocol
	) {
		self.user = user
		self.apiService = apiService
		self.breedPersistenceService = breedPersistenceService
		self.favoritePersistenceService = favoritePersistenceService
		
		Task {
			await loadFavorites()
			await loadBreeds()
		}
	}
}

// MARK: - Breed methods
extension CatBreedStore {
	func fetchBreeds() async throws -> [CatBreed]? {
		return []
	}
	
	func loadBreeds() async {
		print("loading breeds")
		do {
			if let cached = breedPersistenceService.loadBreeds(),
			   !cached.isEmpty {
				print("loaded breeds from cache")
				self.breeds = cached
			} else {
				print("loaded breeds because cache was empty")
				let breeds = try await apiService.fetchBreeds(page: 0, limit: ApiConstants.breedsPageLimit).compactMap { CatBreed(from: $0) }
				let processed = try await processBreeds(breeds)
				
				self.breeds = processed
			}
		} catch {
			print("Failed to load breeds with error \(error.localizedDescription)")
		}
	}
	
	func refreshBreeds() async throws -> [CatBreed] {
		let breeds = try await apiService.fetchBreeds(page: 0, limit: ApiConstants.breedsPageLimit).compactMap { CatBreed(from: $0) }
		
		if breeds.count > 0 {
			breedPersistenceService.clearBreeds()
		}
		
		let processed = try await processBreeds(breeds)
		return processed
	}
	
	func loadNextBreedsPage() async throws -> [CatBreed] {
		guard !hasLoadedAllBreeds,
			  ApiConstants.breedsPageLimit > 0 else {
			return self.breeds
		}
		
		let nextPage = Int(ceil(Double(breeds.count) / Double(ApiConstants.breedsPageLimit)))
		
		print("Loading next page \(nextPage)")
		
		let breeds = try await apiService.fetchBreeds(page: nextPage, limit: ApiConstants.breedsPageLimit)
		
		if breeds.count < ApiConstants.breedsPageLimit {
			hasLoadedAllBreeds = true
		}
		
		let catBreeds = try await processBreeds(breeds.compactMap { CatBreed(from: $0) })
		self.breeds.append(contentsOf: catBreeds)
		return self.breeds
	}
	
	func searchBreed(query: String) async throws -> [CatBreed] {
		do {
			let breeds = try await apiService.searchBreeds(name: query).compactMap { CatBreed(from: $0) }
			return try await processBreeds(breeds)
		}
	}
	
	private func processBreeds(_ breeds: [CatBreed]) async throws -> [CatBreed] {
		var results: [String: ImageResponse] = [:]
		
		if !breeds.isEmpty {
			// Fetch all images
			try await withThrowingTaskGroup(of: (String, ImageResponse).self) { [apiService] group in
				for breed in breeds {
					if breed.imageUrl == nil  {
						group.addTask {
							let response = try await apiService.fetchBreedImage(with: breed.imageId)
							return (breed.id, response)
						}
					}
				}
				
				for try await (breedId, image) in group {
					results[breedId] = image
				}
			}
			
			results.keys.forEach { breedId in
				if let breed = breeds.first(where: { $0.id == breedId }),
				   let image = results[breedId] {
					breed.imageUrl = image.url
				}
			}
			
			// Persisting breeds
			breedPersistenceService.saveBreeds(breeds)
		}
		
		return breeds
	}
}

// MARK: - Favorite methods
extension CatBreedStore {
	func toggleFavorite(breed: CatBreed) async throws {
		try await toggleFavorite(imageId: breed.imageId)
	}
	
	func toggleFavorite(imageId: String) async throws {
		if let favouriteId = favorites.first(where: { $0.imageId == imageId })?.id {
			try await removeFavorite(id: favouriteId, imageId: imageId)
		} else if let breed = breeds.first(where: { $0.imageId == imageId }) {
			try await addFavorite(breed: breed)
		}
	}
	
	func addFavorite(breed: CatBreed) async throws {
		let id = try await apiService.addFavorite(imageId: breed.imageId, userId: user.username)
		favoritePersistenceService.saveFavorite(FavouriteBreed(favoriteId: id, with: breed))
		
		if let favorites = favoritePersistenceService.loadFavorites() {
			self.favorites = favorites
		}
	}
	
	func removeFavorite(id: Int, imageId: String) async throws {
		do {
			let _ = try await apiService.removeFavorite(favoriteId: id)
			favoritePersistenceService.removeFavorite(id: id)
			favorites.removeAll(where: { $0.id == id })
			
			if let favorites = favoritePersistenceService.loadFavorites() {
				self.favorites = favorites
			}
		} catch let error as MeowError {
			if case .noInternetConnection = error {
				try? favoritePersistenceService.savePendingAction(FavoritePendingAction(breedId: imageId, action: .unmarkFavorite(id)))
				let pending = try? favoritePersistenceService.loadPendingActions()
				favoritePersistenceService.removeFavorite(id: id)
				favorites.removeAll(where: { $0.id == id })
			} else {
				throw error
			}
		} catch {
			print("Failed to remove favorite with unhandled error: \(error.localizedDescription)")
		}
	}
	
	func isFavourite(_ breed: CatBreed) -> Bool {
		favorites.first(where: { $0.imageId == breed.imageId }) != nil
	}
	
	func isFavorite(imageId: String) -> Bool {
		favorites.first(where: { $0.imageId == imageId }) != nil
	}
	
	func syncPendingActions() async {
		print("sync pending actions")
		guard let pendingActions = try? favoritePersistenceService.loadPendingActions(),
			  !pendingActions.isEmpty else {
			print("no pending actions to sync")
			return
		}
		
		for action in pendingActions {
			switch action.action {
				case .unmarkFavorite(let id):
					do {
						try await apiService.removeFavorite(favoriteId: id)
						favoritePersistenceService.removeFavorite(id: id)
						favoritePersistenceService.deletePendingAction(id: action.id)
					} catch {
						
					}
				case .markFavorite(let imageId):
					do {
						let response = try await apiService.addFavorite(imageId: imageId, userId: user.username)
						// TODO: save favorite
						favoritePersistenceService.deletePendingAction(id: action.id)
					} catch {
						
					}
			}
		}
	}
	
	
	func fetchFavorites(forceReload: Bool = false) async throws -> [FavouriteBreed] {
		if let cached = favoritePersistenceService.loadFavorites(),
		   !forceReload {
			print("We have cached favorites!!!")
			favorites = cached
			return favorites
		}
		
		var favorites: [Favorite:CatBreed?] = Dictionary(uniqueKeysWithValues: try await apiService.fetchFavorites(userId: user.username).map{ ($0, nil) })
		
		let breeds = breedPersistenceService.loadBreeds()
		
		for favorite in favorites.keys {
			if let breed = breeds?.first(where: { $0.imageId == favorite.image.id }) {
				favorites[favorite] = breed
			} else {
				if let image = try? await apiService.fetchBreedImage(with: favorite.imageId),
				   let breed = image.breeds.first {
					favorites[favorite] = CatBreed(from: breed)
				}
			}
		}
		
		let mapped: [FavouriteBreed] = favorites.compactMap { (key, value) in
			guard let breed = value else { return nil }
			return FavouriteBreed(favoriteId: key.id, with: breed)
		}
		
		self.favorites = mapped
		favoritePersistenceService.clearFavorites()
		favoritePersistenceService.saveFavorites(mapped)
		
		return self.favorites
	}
	
	
	
	// MARK: - Private methods
	private func loadFavorites() async {
		print("loading favorites")
		do {
			_ = try await fetchFavorites(forceReload: true)
		} catch {
			print(error.localizedDescription)
		}
	}
}
