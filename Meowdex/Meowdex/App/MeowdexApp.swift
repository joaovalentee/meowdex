//
//  MeowdexApp.swift
//  Meowdex
//
//  Created by Johnnie on 27/06/2025.
//

import SwiftUI
import SwiftData

@main
struct MeowdexApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
				.catBreedsDataContainer()
				.onAppear {
					print("\(URL.applicationSupportDirectory.path(percentEncoded: false))")
				}
        }
    }
}
