//
//  PersistenceService.swift
//  Meowdex
//
//  Created by Johnnie on 29/06/2025.
//

import Foundation
import SwiftData

class FavoritePersistenceService: FavoritePersistenceServiceProtocol {
	
	
	private let context: ModelContext
	
	init(context: ModelContext) {
		self.context = context
	}
	
	func loadFavoriteIDs() -> [String:Int] {
		guard let favourites = loadFavorites() else { return [:] }
		return Dictionary(uniqueKeysWithValues: favourites.map { ($0.breedId, $0.id) })
	}
	
	func loadFavorites() -> [FavouriteBreed]? {
		do {
			let descriptor = FetchDescriptor<FavouriteBreed>(sortBy: [.init(\.breed, order: .forward)])
			return try context.fetch(descriptor)
		} catch {
			print("Failed to fetch favorites: \(error)")
			return nil
		}
	}
	
	func saveFavorites(_ favorites: [FavouriteBreed]) {
		for favorite in favorites {
			context.insert(favorite)
		}
		saveContext()
	}
	
	func savePendingAction(_ action: FavoritePendingAction) throws {
		print("Saving action \(action)")
		context.insert(action)
		print("Inserted action")
		try context.save()
		print("Saved action")
	}
	
	func loadPendingActions() throws -> [FavoritePendingAction]? {
		print("Loading pending actions...")
		let descriptor = FetchDescriptor<FavoritePendingAction>()
		let actions = try context.fetch(descriptor)
		print("Loaded \(actions.count) pending actions...")
		return actions
	}
	
	func clearPendingActions() {
		guard let actions = try? loadPendingActions() else { return }
		for action in actions {
			context.delete(action)
		}
		saveContext()
	}
	
	func deletePendingAction(id: String) {
		let descriptor = FetchDescriptor<FavoritePendingAction>(predicate: #Predicate { $0.id == id })
		do {
			let results = try context.fetch(descriptor)
			results.forEach { context.delete($0) }
			saveContext()
		} catch {
			print("Failed to delete pending action with id \(id): \(error)")
		}
	}
	
	func clearFavorites() {
		guard let favorites = loadFavorites() else { return }
		for favorite in favorites {
			context.delete(favorite)
		}
		saveContext()
	}
	
	func saveFavorite(_ favorite: FavouriteBreed) {
		context.insert(favorite)
		saveContext()
	}
	
	func removeFavorite(id: Int) {
		let descriptor = FetchDescriptor<FavouriteBreed>(predicate: #Predicate { $0.id == id })
		do {
			let results = try context.fetch(descriptor)
			results.forEach { context.delete($0) }
			saveContext()
		} catch {
			print("Failed to delete favorite with id \(id): \(error)")
		}
	}
	
	func isFavorite(imageId: String) -> Bool {
		let descriptor = FetchDescriptor<FavouriteBreed>(predicate: #Predicate { $0.imageId == imageId })
		
		do {
			let data = try context.fetch(descriptor)
			return !data.isEmpty
		} catch {
			print("Failed to delete favorite with id \(imageId): \(error)")
			return false
		}
	}
	
	
	private func saveContext() {
		do {
			try context.save()
		} catch {
			print("Failed to save context: \(error)")
		}
	}
}
