//
//  BreedCacheMetadata.swift
//  Meowdex
//
//  Created by Johnnie on 27/06/2025.
//

import Foundation
import SwiftData

/// Represents the caching details for cat breeds
@Model
final class BreedCacheMetadata {
	/// Whether last page was already fetched or not
	var isLastPage: Bool
	
	/// Last date when the data was fetched
	var lastFetchData: Date
	
	init(
		isLastPage: Bool,
		lastFetchData: Date
	) {
		self.isLastPage = isLastPage
		self.lastFetchData = lastFetchData
	}
}
