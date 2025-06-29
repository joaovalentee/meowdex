//
//  CatBreedTabView.swift
//  Meowdex
//
//  Created by Johnnie on 29/06/2025.
//

import SwiftUI
import SwiftData

struct CatBreedTabView: View {
	@Environment(\.isNetworkConnected) private var hasNetworkConnection
	
	@StateObject private var store: CatBreedStore
	
	init() {
		let container = try! ModelContainer(for: SwiftData.Schema(
			[CatBreed.self, FavouriteBreed.self, Temperament.self, BreedCacheMetadata.self, FavoritePendingAction.self, User.self]
		), configurations: [ModelConfiguration(isStoredInMemoryOnly: false)])
		_store = StateObject(
			wrappedValue: CatBreedStore(
				user: User(username: "aabbccdd"),
				apiService: TheCatAPIService(),
				breedPersistenceService: BreedPersistanceService(context: container.mainContext),
				favoritePersistenceService: FavoritePersistenceService(context: container.mainContext)
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
		.onChange(of: hasNetworkConnection) { oldValue, newValue in
			if oldValue != newValue && newValue {
				Task {
					await store.syncPendingActions()					
				}
			}
		}
    }
}
