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
	var searchQuery: String = "" {
		didSet {
			if !isLoadingSearch && !searchQuery.isEmpty {
				isLoadingSearch = true
			}
			debounceTask?.cancel()
			debounceTask = Task {
				try? await Task.sleep(for: .milliseconds(300))
				if !Task.isCancelled {
					await filterBreeds()
				}
			}
		}
	}
	private(set) var isLoading: Bool = true
	private(set) var isLoadingSearch: Bool = false
	private(set) var isLoadingMore: Bool = false
	private(set) var errorMessage: String? = nil
	private(set) var favouriteIDs: [String:Int] = [:]
	
	
	// MARK: - Internal
	private var debounceTask: Task<Void, Never>?
	private var userId: String = "aabbccdd"
	
	// MARK: - Dependencies
	private let apiService: CatBreedAPIService
	private let favoritePersistenceService: FavoritePersistenceServiceProtocol
	private let breedPersistanceService: BreedPersistanceServiceProtocol
	
	// MARK: - Init
	init(
		apiService: CatBreedAPIService = TheCatAPIService(),
		breedPersistanceService: BreedPersistanceServiceProtocol,
		favoritePersistenceService: FavoritePersistenceServiceProtocol
	) {
		self.apiService = apiService
		self.favoritePersistenceService = favoritePersistenceService
		self.breedPersistanceService = breedPersistanceService
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
			breedPersistanceService: BreedPersistanceService(context: modelContext),
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
			if let cached = breedPersistanceService.loadBreeds(),
			   !cached.isEmpty {
				print("loaded breeds from cache")
				self.breeds = cached
			} else {
				print("loaded breeds because cache was empty")
				let breeds = try await apiService.fetchBreeds(page: 0, limit: ApiConstants.breedsPageLimit).compactMap { CatBreed(from: $0) }
				let processed = try await processBreeds(breeds)
				
				self.breeds = processed
				self.filteredBreeds = processed
			}
		} catch {
			errorMessage = error.localizedDescription
		}
		
		isLoading = false
	}
	
	func refreshBreeds() async {
		print("refreshing breeds")
		do {
			let breeds = try await apiService.fetchBreeds(page: 0, limit: ApiConstants.breedsPageLimit).compactMap { CatBreed(from: $0) }
			
			if breeds.count > 0 {
				breedPersistanceService.clearBreeds()
			}
			
			let processed = try await processBreeds(breeds)
			self.breeds = processed
			self.filteredBreeds = processed
			self.hasLoadedAllBreeds = false
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
			
			let catBreeds = try await processBreeds(breeds.compactMap { CatBreed(from: $0) })
			self.breeds.append(contentsOf: catBreeds)
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
	
	func clearSearch() {
		print("Clearing search")
		self.filteredBreeds = []
	}
	
	// MARK: - Private Methods
	func filterBreeds() async {
		print("Searching by \(searchQuery)")
		
		guard !searchQuery.isEmpty else {
			self.filteredBreeds = []
			return
		}
		
		do {
			let breeds = try await apiService.searchBreeds(name: searchQuery).compactMap { CatBreed(from: $0) }
			
			try Task.checkCancellation()
			
			self.filteredBreeds = try await processBreeds(breeds)
			self.isLoadingSearch = false
		} catch {
			//self.errorMessage = error.localizedDescription
			// TODO: check if no internet connection and search offline
			self.isLoadingSearch = false
			self.filteredBreeds = []
		}
	}
	
	func loadFavorites() async {
		self.favouriteIDs = await favoritePersistenceService.loadFavoriteIDs()
	}
	
	private func processBreeds(_ breeds: [CatBreed]) async throws -> [CatBreed] {
		var results: [String: ImageResponse] = [:]
		
		if !breeds.isEmpty {
			// Fetch all images
			try await withThrowingTaskGroup(of: (String, ImageResponse).self) { [apiService] group in
				for breed in breeds {
					if breed.image == nil,
					   let imageId = breed.imageId {
						group.addTask {
							let response = try await apiService.fetchBreedImage(with: imageId)
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
			breedPersistanceService.saveBreeds(breeds)
		}
		
		return breeds
	}
}
