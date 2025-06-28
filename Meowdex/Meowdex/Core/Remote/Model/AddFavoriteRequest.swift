//
//  AddFavoriteRequest.swift
//  Meowdex
//
//  Created by Johnnie on 28/06/2025.
//

import Foundation

struct AddFavoriteRequest: Encodable {
	let imageId: String
	let userId: String
	
	enum CodingKeys: String, CodingKey {
		case imageId = "image_id"
		case userId = "sub_id"
	}
}
