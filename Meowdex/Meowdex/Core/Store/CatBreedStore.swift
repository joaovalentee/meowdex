//
//  CatBreedStore.swift
//  Meowdex
//
//  Created by Johnnie on 29/06/2025.
//

import Foundation

/// CatBreedStore representes a single source of truth to be used for all the viewModels.
/// The usage of a store reduces the duplication of code and centralizes the business logic in one place, leaving the viewModels to
/// do their job, i.e., bind the model to the view.
///
/// The usage of ObservableObject helps with dependency injection with the @EnvironmentObject annotation.
/// @Published allows the viewModels to receive updates whenever the values they subscribe are updated,  keeping the view always up to date.
@MainActor
class CatBreedStore: ObservableObject {
	
	// MARK: - Public
	/// List of cat breeds
	@Published var breeds: [CatBreed] = []
	/// Wherer or not all pages have been fetched
	private(set) var hasLoadedAllBreeds: Bool = false
	/// All favorite cat breeds
	@Published var favorites: [FavouriteBreed] = []
	
	// MARK: - Private
	/// The API supports grouping the favorites by user_id, so we're keeping track of the user
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
		
		/// Loading all data as soon as the Store is initialized
		Task {
			await loadFavorites()
			await loadBreeds()
		}
		Task {
			await syncPendingActions()
		}
	}
}

// MARK: - Breed methods
extension CatBreedStore {
	/// Refreshes the list of cat breeds.
	/// If load from remote storage is successful, clears current cache and saves new data
	func refreshBreeds() async throws -> [CatBreed] {
		let breeds = try await apiService.fetchBreeds(page: 0, limit: ApiConstants.breedsPageLimit).compactMap { CatBreed(from: $0) }
		
		if breeds.count > 0 {
			hasLoadedAllBreeds = false
			breedPersistenceService.clearBreeds()
		}
		
		let processed = try await processBreeds(breeds)
		// Persisting breeds
		breedPersistenceService.saveBreeds(processed)
		
		self.breeds = processed
		return processed
	}
	
	/// Loads the next page if last past hasn't been reached.
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
		// Persisting breeds
		breedPersistenceService.saveBreeds(catBreeds)
		
		self.breeds.append(contentsOf: catBreeds)
		return self.breeds
	}
	
	/// Searches for a specific breed using a query string
	func searchBreed(query: String) async throws -> [CatBreed] {
		do {
			let breeds = try await apiService.searchBreeds(name: query).compactMap { CatBreed(from: $0) }
			return try await processBreeds(breeds)
		}
	}
	
	/// Fetches first page of breeds.
	/// Used on load method
	private func fetchBreeds(forceReload: Bool = false) async throws -> [CatBreed]? {
		if let cached = breedPersistenceService.loadBreeds(),
		   !cached.isEmpty {
			print("loaded breeds from cache")
			self.breeds = cached
			if !forceReload {
				return self.breeds
			}
		}
		
		print("loaded breeds because cache was empty")
		let breeds = try await apiService.fetchBreeds(page: 0, limit: ApiConstants.breedsPageLimit).compactMap { CatBreed(from: $0) }
		let processed = try await processBreeds(breeds)
		
		self.breeds = processed
		
		return self.breeds
	}
	
	/// loadBreeds() is only used when then the Store is initialized to load all the data.
	/// At this point we don't care about errors.
	private func loadBreeds() async {
		print("loading breeds")
		do {
			_ = try await fetchBreeds()
		} catch {
			print("Failed to load breeds with error \(error.localizedDescription)")
		}
	}
	
	/// Processes a cat breed to get its image data
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
		}
		
		return breeds
	}
}

// MARK: - Favorite methods
extension CatBreedStore {
	/// Adds or removes a favorite based on a specified breed
	func toggleFavorite(breed: CatBreed) async throws {
		try await toggleFavorite(imageId: breed.imageId)
	}
	
	/// Adds or removes a favorite based on a specified imageId.
	/// Favorites are added based on the breed image ID and removed based on the favorite ID.
	func toggleFavorite(imageId: String) async throws {
		if let favouriteId = favorites.first(where: { $0.imageId == imageId })?.id {
			try await removeFavorite(id: favouriteId, imageId: imageId)
		} else if let breed = breeds.first(where: { $0.imageId == imageId }) {
			try await addFavorite(breed: breed)
		}
	}
	
	/// Marks a cat breed as favorite
	func addFavorite(breed: CatBreed) async throws {
		let id = try await apiService.addFavorite(imageId: breed.imageId, userId: user.username)
		favoritePersistenceService.saveFavorite(FavouriteBreed(favoriteId: id, with: breed))
		
		if let favorites = favoritePersistenceService.loadFavorites() {
			self.favorites = favorites
		}
	}
	
	/// Unmarks a cat breed as favorite
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
				favoritePersistenceService.removeFavorite(id: id)
				favorites.removeAll(where: { $0.id == id })
			} else {
				throw error
			}
		} catch {
			print("Failed to remove favorite with unhandled error: \(error.localizedDescription)")
		}
	}

	/// Checks if a specified imageId is marked as favorite
	func isFavorite(imageId: String) -> Bool {
		favorites.first(where: { $0.imageId == imageId }) != nil
	}
	
	/// Syncs pending actions (to add or remove a favorite) that we're performed while in offline
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
	
	/// Fetches the favorites
	func fetchFavorites(forceReload: Bool = false) async throws -> [FavouriteBreed] {
		var hasCached: Bool = false
		if let cached = favoritePersistenceService.loadFavorites(),
		   !cached.isEmpty {
			print("We have cached favorites!!!")
			favorites = cached
			hasCached = true
			
			if !forceReload {
				return favorites
			}
		}
		
		print("Feching favorites")
		
		/// Matching favorites with already fetched cat breeds
		var favorites: [Favorite:CatBreed?] = Dictionary(uniqueKeysWithValues: try await apiService.fetchFavorites(userId: user.username).map{ ($0, nil) })
		
		/// Checking if we have the breeds already fetched, otherwise, fetching important data for the specific breeds
		for favorite in favorites.keys {
			if let breed = breeds.first(where: { $0.imageId == favorite.image.id }) {
				favorites[favorite] = breed
			} else {
				/// If we don't have the breed offline, we need to get the image to show
				if let image = try? await apiService.fetchBreedImage(with: favorite.imageId),
				   let breed = image.breeds.first,
				   let catBreed = CatBreed(from: breed) {
					catBreed.imageUrl = image.url
					favorites[favorite] = catBreed
				}
			}
		}
		
		/// Creating favorite breeds
		let mapped: [FavouriteBreed] = favorites.compactMap { (key, value) in
			guard let breed = value else { return nil }
			return FavouriteBreed(favoriteId: key.id, with: breed)
		}
		
		self.favorites = mapped
		
		if hasCached {
			favoritePersistenceService.clearFavorites()
		}
		
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
