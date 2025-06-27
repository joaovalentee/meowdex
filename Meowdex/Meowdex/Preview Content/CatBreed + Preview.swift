//
//  CatBreed + Preview.swift
//  Meowdex
//
//  Created by Johnnie on 27/06/2025.
//

import SwiftUI

extension CatBreed {
	static var preview: [CatBreed] = {
		[
			CatBreed(
				id: "cat-1",
				breed: "Cat Breed 1",
				origin: "Portugal",
				temperament: [
					.init(name:"Easy"),
					.init(name: "Energetic")
				],
				details: "A very beatiful cat",
				maxLifespan: 11,
				imageId: "lOl0J96On"
			),
			CatBreed(
				id: "cat-2",
				breed: "Cat Breed 2",
				origin: "France",
				temperament: [.init(name: "Hard")],
				details: "Run if you cross with one of this cats",
				maxLifespan: 12,
				imageId: "lOl0J96On"
			),
			CatBreed(
				id: "cat-3",
				breed: "Cat Breed 3",
				origin: "Spain",
				temperament: [.init(name: "Hard")],
				details: "Run if you cross with one of this cats",
				maxLifespan: 13,
				imageId: "lOl0J96On"
			),
			CatBreed(
				id: "cat-4",
				breed: "Cat Breed 4",
				origin: "China",
				temperament: [.init(name: "Hard")],
				details: "Run if you cross with one of this cats",
				maxLifespan: 14,
				imageId: "lOl0J96On"
			),
		]
	}()
}
