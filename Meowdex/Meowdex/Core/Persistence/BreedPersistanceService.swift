//
//  BreedPersistanceService.swift
//  Meowdex
//
//  Created by Johnnie on 29/06/2025.
//

import Foundation
import SwiftData

class BreedPersistanceService: BreedPersistanceServiceProtocol {
	
	private let context: ModelContext
	
	init(context: ModelContext) {
		self.context = context
	}
	
	func saveBreeds(_ breeds: [CatBreed]) {
		for breed in breeds {
			context.insert(breed)
		}
		saveContext()
	}
	
	func loadBreeds() -> [CatBreed]? {
		let descriptor = FetchDescriptor<CatBreed>(sortBy: [.init(\.breed, order: .forward)])
		
		do {
			let cached = try context.fetch(descriptor)
			return cached
		} catch {
			print("Failed to fetch cached breeds: \(error)")
			return nil
		}
	}
	
	func clearBreeds() {
		do {
			let breeds = try context.fetch(FetchDescriptor<CatBreed>())
			breeds.forEach { context.delete($0) }
			saveContext()
		} catch {
			print("Failed to clear breeds cache: \(error)")
		}
	}
	
	
	// MARK: - Context Save
	private func saveContext() {
		do {
			try context.save()
		} catch {
			print("Failed to save context: \(error)")
		}
	}
}
