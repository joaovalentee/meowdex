//
//  Favorite.swift
//  Meowdex
//
//  Created by Johnnie on 27/06/2025.
//

import Foundation

struct Favorite: Decodable {
	let id: Int
	let userId: String
	let imageId: String
	let subId: String
	let createdAt: String
	let image: ImageData
	
	struct ImageData: Decodable {
		let id: String
		let url: String
	}
	
	enum CodingKeys: String, CodingKey {
		case id
		case userId = "user_id"
		case imageId = "image_id"
		case subId = "sub_id"
		case createdAt = "created_at"
		case image
	}
}
