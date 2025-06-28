//
//  BreedListViewModel.swift
//  Meowdex
//
//  Created by Johnnie on 28/06/2025.
//

import Foundation
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
	private(set) var favouriteIDs: Set<String> = []
	
	// MARK: - Dependencies
	private let apiService: CatBreedAPIService
	//private let persistenceService: PersistenceServiceProtocol
	
	// MARK: - Init
	init(
		apiService: CatBreedAPIService = TheCatAPIService()
		//persistenceService: PersistenceServiceProtocol = PersistenceService()
	) {
		self.apiService = apiService
		//self.persistenceService = persistenceService
		Task {
			await loadBreeds()
		}
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
	
	func toggleFavourite(for breed: CatBreed) {
		if favouriteIDs.contains(breed.id) {
			favouriteIDs.remove(breed.id)
//			persistenceService.removeFavourite(id: breed.id)
		} else {
			favouriteIDs.insert(breed.id)
//			persistenceService.saveFavourite(id: breed.id)
		}
	}
	
	func isFavourite(_ breed: CatBreed) -> Bool {
		favouriteIDs.contains(breed.id)
	}
	
	// MARK: - Private Methods
	func filterBreeds() {
		
	}
}
