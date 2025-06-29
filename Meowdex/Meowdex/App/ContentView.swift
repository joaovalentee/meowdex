//
//  ContentView.swift
//  Meowdex
//
//  Created by Johnnie on 27/06/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
		TabView {
			ForEach(AppScreen.allCases) { screen in
				screen.destination()
					.tag(screen)
					.tabItem { screen.label }
			}
		}
    }
}

#Preview {
    ContentView()
		.catBreedsDataContainerPreview(populateWith: CatBreed.preview)
}
