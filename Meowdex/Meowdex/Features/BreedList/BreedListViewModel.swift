//
//  BreedListViewModel.swift
//  Meowdex
//
//  Created by Johnnie on 28/06/2025.
//

import Foundation
import SwiftData
import Observation
import Combine

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
	
	private var cancellables = Set<AnyCancellable>()
	
	
	// MARK: - Internal
	private var debounceTask: Task<Void, Never>?
	
	// MARK: - Dependencies
	private let store: CatBreedStore
	
	// MARK: - Init
	init(
		store: CatBreedStore
	) {
		self.store = store
		
		store.$favorites.sink { [weak self] favorites in
			self?.favouriteIDs = Dictionary(uniqueKeysWithValues: favorites.map { ($0.breedId, $0.id) })
		}.store(in: &cancellables)
		
		store.$breeds
			.dropFirst() // avoids setting loading indicator to false with first publish
			.sink { [weak self] breeds in
				print("received breeds \(breeds.count)")
				if self?.isLoading == true {
					self?.isLoading = false
				}
				self?.breeds = breeds
			}.store(in: &cancellables)
	}

	
	// MARK: - Public Methods
	
	func refreshBreeds() async {
		print("refreshing breeds")
		do {
			let breeds = try await store.refreshBreeds()
			self.breeds = breeds
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
	
		isLoadingMore = true
			
		do {
			let breeds = try await store.loadNextBreedsPage()
			self.breeds = breeds
		} catch {
			errorMessage = error.localizedDescription
		}
		
		isLoadingMore = false
	}
	
	func toggleFavorite(for breed: CatBreed) async {
		do {
			try await store.toggleFavorite(breed: breed)
		} catch {
			errorMessage = error.localizedDescription
		}
	}
	
	func isFavorite(_ breed: CatBreed) -> Bool {
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
		
		self.isLoadingSearch = true
		
		do {
			let searched = try await store.searchBreed(query: searchQuery)
			
			try Task.checkCancellation()
			
			self.filteredBreeds = searched
		} catch _ as CancellationError {
			// Ignore
		} catch {
			self.filteredBreeds = breeds.filter{ $0.breed.localizedCaseInsensitiveContains(searchQuery)  }
		}
		
		self.isLoadingSearch = false
	}
}
