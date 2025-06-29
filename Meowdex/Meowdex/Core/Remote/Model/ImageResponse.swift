//
//  ImageResponse.swift
//  Meowdex
//
//  Created by Johnnie on 29/06/2025.
//

import Foundation

struct ImageResponse : Codable {
	let id: String
	let url: String
	let breeds: [Breed]
	let width: Int
	let height: Int
}
