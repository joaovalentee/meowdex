//
//  FavoriteBreedListViewModel.swift
//  Meowdex
//
//  Created by Johnnie on 29/06/2025.
//

import Foundation
import Observation
import SwiftData
import SwiftUI
import Combine

@Observable
@MainActor
/// Binds the data for the favorite breed list view
class FavoriteBreedListViewModel {
	
	// MARK: - Public Properties
	/// List of favorites cat breeds
	private(set) var favorites: [FavouriteBreed] = []
	/// Loading indication
	private(set) var isLoading: Bool = true
	/// Error message to show on screen
	var errorMessage: String? = nil
	/// Average favorites lifespan
	var averageLifespan: Int? {
		guard favorites.count > 0 else { return nil }
		return favorites.reduce(into: 0, { $0 = $0 + $1.maxLifespan }) / favorites.count
	}
	
	/// Binds the errorMessage to a Bool to display an alert on screen
	var hasError: Binding<Bool> {
		Binding {
			self.errorMessage != nil
		} set: { newValue in
			if !newValue {
				self.errorMessage = nil
			}
		}
	}
	
	/// Holds the observations
	private var cancellables = Set<AnyCancellable>()
	
	// MARK: - Dependencies
	private let store: CatBreedStore
	
	// MARK: - Init
	init(
		store: CatBreedStore
	) {
		self.store = store
		self.favorites = store.favorites
		
		observeFavorites()
	}
	
	// MARK: - Public methods
	func removeFavorite(id: Int, imageId: String) async {
		do {
			try await store.removeFavorite(id: id, imageId: imageId)
		} catch let e as MeowError {
			errorMessage = e.localizedDescription
		} catch {
			print("handle error without message: \(error.localizedDescription)")
		}
	}
	
	/// Sync actions happen without the user noticing it, so we're not handling any error
	func syncPendingActions() async {
		await store.syncPendingActions()
	}
	
	/// In case refresh fails, we  might want to show some errors (no internet connection)
	func refreshFavorites() async {
		do {
			_ = try await store.fetchFavorites(forceReload: true)
		} catch let e as MeowError {
			errorMessage = e.localizedDescription
		} catch {
			print("handle error without message: \(error.localizedDescription)")
		}
	}
	
	// MARK: - Private methods
	private func observeFavorites() {
		store.$favorites
			.sink { [weak self] favorites in
				self?.favorites = favorites
				if self?.isLoading == true {
					self?.isLoading = false
				}
			}.store(in: &cancellables)
	}
}
