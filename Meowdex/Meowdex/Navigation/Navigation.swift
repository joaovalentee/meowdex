//
//  Navigation.swift
//  Meowdex
//
//  Created by Johnnie on 28/06/2025.
//

import SwiftUI
import Observation

@Observable
final class Navigation<NavigationOptions: Hashable> {
	var path: NavigationPath = NavigationPath()
	
	/// Adds a view to the stack
	func push(_ page: NavigationOptions) {
		path.append(page)
	}
	
	/// Removes the last view on the stack
	func pop() {
		path.removeLast()
	}
	
	/// Removes all the views from the stack and returns to the home view
	func popToRoot() {
		path.removeLast(path.count)
	}
}


