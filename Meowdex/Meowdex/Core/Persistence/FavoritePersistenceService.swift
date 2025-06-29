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
	
	func loadFavoriteIDs() async -> [String:Int] {
		do {
			let descriptor = FetchDescriptor<FavouriteBreed>()
			let favourites = try context.fetch(descriptor)
			return Dictionary(uniqueKeysWithValues: favourites.map { ($0.id, $0.favouriteId) })
		} catch {
			print("Failed to fetch favourites: \(error)")
			return [:]
		}
	}
	
	func saveFavorite(_ favorite: FavouriteBreed) {
		context.insert(favorite)
		saveContext()
	}
	
	func removeFavorite(id: Int) {
		let descriptor = FetchDescriptor<FavouriteBreed>(predicate: #Predicate { $0.favouriteId == id })
		do {
			let results = try context.fetch(descriptor)
			results.forEach { context.delete($0) }
			saveContext()
		} catch {
			print("Failed to delete favourite with id \(id): \(error)")
		}
	}
	
	func isFavorite(imageId: String) -> Bool {
		let descriptor = FetchDescriptor<FavouriteBreed>(predicate: #Predicate { $0.imageId == imageId })
		
		do {
			let data = try context.fetch(descriptor)
			return !data.isEmpty
		} catch {
			print("Failed to delete favourite with id \(imageId): \(error)")
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
