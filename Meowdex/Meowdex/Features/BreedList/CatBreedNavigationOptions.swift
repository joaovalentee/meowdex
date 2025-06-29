//
//  CatBreedNavigationOptions.swift
//  Meowdex
//
//  Created by Johnnie on 29/06/2025.
//

import SwiftUI

enum CatBreedNavigationOptions: Hashable {
	case details(CatBreed)
	
	@ViewBuilder
	func viewForPage() -> some View {
		switch self {
			case .details(let cat):
				BreedDetailsScreen(breed: cat)
		}
	}
}
