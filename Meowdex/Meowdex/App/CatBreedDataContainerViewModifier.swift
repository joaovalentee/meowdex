//
//  CatBreedDataContainerViewModifier.swift
//  Meowdex
//
//  Created by Johnnie on 27/06/2025.
//

import SwiftUI
import SwiftData

struct CatBreedDataContainerViewModifier: ViewModifier {
    
	private let container: ModelContainer
	private let data: [any PersistentModel]?
	private let inMemory: Bool
	
	init(
		inMemory: Bool,
		populateWith data: [any PersistentModel]? = nil
	) {
		self.container = try! ModelContainer(for: SwiftData.Schema(
			[CatBreed.self, FavouriteBreed.self, Temperament.self, BreedCacheMetadata.self]
		), configurations: [ModelConfiguration(isStoredInMemoryOnly: inMemory)])
		self.data = data
		self.inMemory = inMemory
	}
	
	func body(content: Content) -> some View {
		content
			.modelContainer(container)
			.task {
				if let data, inMemory {
					data.forEach {
						container.mainContext.insert($0)
					}
				}
			}
	}
}

extension View {
	func catBreedsDataContainer() -> some View {
		modifier(CatBreedDataContainerViewModifier(inMemory: false))
	}
	
	// Used for UI previews
	func catBreedsDataContainerPreview(populateWith data: [any PersistentModel]) -> some View {
		modifier(CatBreedDataContainerViewModifier(inMemory: true, populateWith: data))
	}
}
