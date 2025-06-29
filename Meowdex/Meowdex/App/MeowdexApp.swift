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
	/// Monitors the internet connectivity
	@State private var networkMonitor = NetworkMonitor.shared
	
    var body: some Scene {
        WindowGroup {
            ContentView()
				.environment(\.isNetworkConnected, networkMonitor.isConnected)
        }
    }
}
