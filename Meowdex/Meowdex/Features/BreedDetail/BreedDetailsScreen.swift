//
//  BreedDetailsScreen.swift
//  Meowdex
//
//  Created by Johnnie on 28/06/2025.
//

import SwiftUI

struct BreedDetailsScreen: View {
	@Environment(\.modelContext) private var modelContext
	
	let breed: CatBreed

    var body: some View {
		BreedDetailsView(breed: breed, context: modelContext)
    }
}

#Preview {
	NavigationStack {
		BreedDetailsScreen(breed: CatBreed.preview.first!)
	}
}
