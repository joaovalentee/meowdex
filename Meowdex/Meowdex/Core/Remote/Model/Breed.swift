//
//  Breed.swift
//  Meowdex
//
//  Created by Johnnie on 27/06/2025.
//

import Foundation

struct Breed : Codable {
	let id: String
	let name: String
	let temperament: String
	let origin: String
	let description: String
	let lifespan: String
	let imageId: String
	
	enum CodingKeys: String, CodingKey {
		case id
		case name
		case temperament
		case origin
		case description
		case lifespan = "life_span"
		case imageId = "reference_image_id"
	}
}
