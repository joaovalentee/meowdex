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
class FavouriteBreed {
	/// A unique identifier associated with cat breed.
	@Attribute(.unique) var id: String
	
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
	var imageId: String?
	
	/// The id of the favourite
	var favouriteId: Int
	
	/// Creates a new cat breed from the specified values.
	init(
		id: String,
		favouriteId: Int,
		breed: String,
		origin: String,
		temperament: [Temperament],
		details: String,
		maxLifespan: Int,
		imageId: String?
	) {
		self.id = id
		self.favouriteId = favouriteId
		self.breed = breed
		self.origin = origin
		self.temperament = temperament
		self.details = details
		self.maxLifespan = maxLifespan
		self.imageId = imageId
	}
	
	convenience init(
		favoriteId: Int,
		with breed: CatBreed
	) {
		self.init(
			id: breed.id,
			favouriteId: favoriteId,
			breed: breed.breed,
			origin: breed.origin,
			temperament: breed.temperament,
			details: breed.details,
			maxLifespan: breed.maxLifespan,
			imageId: breed.imageId
		)
	}
}
