//
//  Temperament.swift
//  Meowdex
//
//  Created by Johnnie on 27/06/2025.
//

import SwiftData

/// A representation of a cat temperament
/// It is used to store a list of strings which are not supported by SwiftData
@Model
final class Temperament {
	/// A unique name associated with a breed temperament.
	@Attribute(.unique) var name: String
	
	/// Creates a temperament from the specified values.
	init(name: String) {
		self.name = name
	}
	
	@Relationship(deleteRule: .cascade, inverse: \CatBreed.temperament)
	var breeds: [CatBreed] = []
}

extension Temperament: Identifiable {
	var id: String { name }
}

// A string representation of the temperament.
extension Temperament {
	var description: String {
		"\(name)"
	}
}
