//
//  BreedPersistanceServiceProtocol.swift
//  Meowdex
//
//  Created by Johnnie on 29/06/2025.
//

import Foundation

protocol BreedPersistanceServiceProtocol {
	func saveBreeds(_ breeds: [CatBreed])
	func loadBreeds() -> [CatBreed]?
	func clearBreeds()
}
