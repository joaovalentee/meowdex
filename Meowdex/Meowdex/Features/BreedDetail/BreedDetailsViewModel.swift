//
//  BreedDetailsViewModel.swift
//  Meowdex
//
//  Created by Johnnie on 28/06/2025.
//

import Foundation
import Observation

@Observable
@MainActor
class BreedDetailsViewModel {
	
	// MARK: - Public Properties
	private(set) var imageUrl: String?
	private(set) var imageId: String
	private(set) var name: String
	private(set) var temperament: [Temperament]
	private(set) var origin: String
	private(set) var description: String
	var isFavorite: Bool {
		store.isFavorite(imageId: imageId)
	}
	
	// MARK: - Dependencies
	private let store: CatBreedStore
	
	// MARK: - Init
	init(
		imageUrl: String?,
		name: String,
		imageId: String,
		temperament: [Temperament],
		origin: String,
		description: String,
		store: CatBreedStore
	) {
		self.imageUrl = imageUrl
		self.name = name
		self.temperament = temperament
		self.origin = origin
		self.description = description
		self.store = store
		self.imageId = imageId
	}
	
	convenience init(
		breed: CatBreed,
		store: CatBreedStore
	) {
		self.init(
			imageUrl: breed.imageUrl,
			name: breed.breed,
			imageId: breed.imageId,
			temperament: breed.temperament,
			origin: breed.origin,
			description: breed.details,
			store: store
		)
	}
	
	convenience init(
		favorite: FavouriteBreed,
		store: CatBreedStore
	) {
		self.init(
			imageUrl: favorite.imageUrl,
			name: favorite.breed,
			imageId: favorite.imageId,
			temperament: favorite.temperament,
			origin: favorite.origin,
			description: favorite.details,
			store: store
		)
	}
	
	// MARK: - Public Methods
	
	func toggleFavorite() async {
		try? await store.toggleFavorite(imageId: imageId)
	}
}
