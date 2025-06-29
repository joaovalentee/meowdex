//
//  FavouriteBreed.swift
//  Meowdex
//
//  Created by Johnnie on 27/06/2025.
//

import SwiftData

/// A representation of a favourite cat breed.
/// Favourite cat breeds are stored separated from the CatBreed to allow cache management and to
/// show the favorites list independent from the list of cat breeds.
@Model
class FavouriteBreed: Identifiable {
	/// A unique identifier associated with the favorite
	@Attribute(.unique) var id: Int
	
	/// The name of the cat breed
	var breed: String
	
	/// The origin of the cat breed
	var origin: String
	
	/// A list of temperaments of the cat breed
	var temperament: [Temperament]
	
	/// A description of the cat breed
	var details: String
	
	/// The maximum lifespan for the cat breed
	var maxLifespan: Int
	
	/// The id of the image of the cat breed
	var imageId: String
	
	/// The id of the image of the cat breed
	var imageUrl: String?
	
	/// A unique identifier associated with cat breed.
	var breedId: String
	
	/// Creates a new cat breed from the specified values.
	init(
		id: Int,
		breedId: String,
		breed: String,
		origin: String,
		temperament: [Temperament],
		details: String,
		maxLifespan: Int,
		imageId: String,
		imageUrl: String?
	) {
		self.id = id
		self.breedId = breedId
		self.breed = breed
		self.origin = origin
		self.temperament = temperament
		self.details = details
		self.maxLifespan = maxLifespan
		self.imageId = imageId
		self.imageUrl = imageUrl
	}
	
	convenience init(
		favoriteId: Int,
		with breed: CatBreed
	) {
		self.init(
			id: favoriteId,
			breedId: breed.id,
			breed: breed.breed,
			origin: breed.origin,
			temperament: breed.temperament,
			details: breed.details,
			maxLifespan: breed.maxLifespan,
			imageId: breed.imageId,
			imageUrl: breed.imageUrl
		)
	}
	
	convenience init(
		from model: Favorite,
		with breed:  CatBreed
	) {
		self.init(
			favoriteId: model.id,
			with: breed
		)
	}
}

extension FavouriteBreed: CustomStringConvertible {
	var description: String {
		"\(id) \(breedId) \(breed) \(origin) \(temperament) \(details) \(maxLifespan) \(imageId) \(imageUrl ?? "")"
	}
}
