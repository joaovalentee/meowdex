//
//  User.swift
//  Meowdex
//
//  Created by Johnnie on 29/06/2025.
//

import SwiftData

/// A representation of a user
/// It is used to store a user id to sync the favorites data
@Model
final class User {
	/// A unique username associated with a user
	@Attribute(.unique) var username: String
	
	/// Creates a user from the specified values.
	init(username: String) {
		self.username = username
	}
}

extension User: Identifiable {
	var id: String { username }
}

// A string representation of the user.
extension User {
	var description: String {
		"\(username)"
	}
}

