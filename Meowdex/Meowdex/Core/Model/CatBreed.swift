//
//  CatBreed.swift
//  Meowdex
//
//  Created by Johnnie on 27/06/2025.
//

import SwiftData

/// A representation of a cat breed
/// A CatBreed represents a breed that is listed and searched on the main screen
@Model
class CatBreed: Identifiable {
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
	var imageId: String
	
	/// The url of the image
	var imageUrl: String? = nil
	
	/// Creates a new cat breed from the specified values.
	init(
		id: String,
		breed: String,
		origin: String,
		temperament: [Temperament],
		details: String,
		maxLifespan: Int,
		imageId: String
	) {
		self.id = id
		self.breed = breed
		self.origin = origin
		self.temperament = temperament
		self.details = details
		self.maxLifespan = maxLifespan
		self.imageId = imageId
	}
}


// A string represenation of the cat breed.
extension CatBreed: CustomStringConvertible {
	var description: String {
		"\(id) \(breed) [\(temperament)] \(origin) \(maxLifespan) \(imageId) \(details)"
	}
}

extension CatBreed {
	convenience init?(from model: Breed) {
		guard let imageId = model.imageId,
			  let lifespan = model.lifespan.components(separatedBy: " - ").compactMap({ Int($0.trimmingCharacters(in: .whitespaces)) }).max() else {
			return nil
		}
		
		self.init(
			id: model.id,
			breed: model.name,
			origin: model.origin,
			temperament: model.temperament
				.split(separator: ",")
				.map { Temperament(name: $0.trimmingCharacters(in: .whitespacesAndNewlines)) },
			details: model.description,
			maxLifespan: lifespan,
			imageId: imageId
		)
	}
}
