//
//  BreedDetailsScreen.swift
//  Meowdex
//
//  Created by Johnnie on 28/06/2025.
//

import SwiftUI

struct BreedDetailsScreen: View {
	@EnvironmentObject private var store: CatBreedStore
	
	let breed: CatBreed

    var body: some View {
		BreedDetailsView(breed: breed, store: store)
    }
}

struct FavoriteDetailsScreen: View {
	@EnvironmentObject private var store: CatBreedStore
	
	let favorite: FavouriteBreed
	
	var body: some View {
		BreedDetailsView(favorite: favorite, store: store)
	}
}


#Preview {
	NavigationStack {
		BreedDetailsScreen(breed: CatBreed.preview.first!)
	}
}
