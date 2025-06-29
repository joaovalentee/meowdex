//
//  CatBreedTabView.swift
//  Meowdex
//
//  Created by Johnnie on 29/06/2025.
//

import SwiftUI
import SwiftData

struct CatBreedTabView: View {
	@StateObject private var store: CatBreedStore
	
	init(modelContext: ModelContext) {
		_store = StateObject(
			wrappedValue: CatBreedStore(
				user: User(username: "aabbccdd"),
				apiService: TheCatAPIService(),
				breedPersistenceService: BreedPersistanceService(context: modelContext),
				favoritePersistenceService: FavoritePersistenceService(context: modelContext)
			)
		)
	}
	
    var body: some View {
		TabView {
			ForEach(AppScreen.allCases) { screen in
				screen.destination()
					.tag(screen)
					.tabItem { screen.label }
			}
		}
		.environmentObject(store)
    }
}

//#Preview {
//    CatBreedTabView()
//}
