//
//  ApiConstants.swift
//  Meowdex
//
//  Created by Johnnie on 27/06/2025.
//

import Foundation

struct ApiConstants {
	static let baseURL: String = "https://api.thecatapi.com/v1"
	static let apiKeyHeader: String = "x-api-key"
	
	static let apiQueryPageLabel: String = "page"
	static let apiQueryLimitLabel: String = "limit"
	static let apiQueryBreedNameLabel: String = "q"
	static let apiQueryImageLabel: String = "attach_image"
	static let apiQueryUserIdLabel: String = "sub_id"
	
	static let breedsPageLimit: Int = 12
	
	static func buildGetBreedsRequest(
		page: Int,
		limit: Int
	) -> URLRequest? {
		var components = URLComponents(string: "\(baseURL)/breeds")
		
		components?.queryItems = [
			URLQueryItem(name: apiQueryPageLabel, value: "\(page)"),
			URLQueryItem(name: apiQueryLimitLabel, value: "\(limit)"),
		]
		
		guard let url = components?.url else {
			return nil
		}
		
		return buildAuthenticatedRequest(with: url, method: .get)
	}
	
	static func buildGetSearchBreedsRequest(
		name: String
	) -> URLRequest? {
		var components = URLComponents(string: "\(baseURL)/breeds/search")
		
		components?.queryItems = [
			URLQueryItem(name: apiQueryBreedNameLabel, value: name),
			URLQueryItem(name: apiQueryImageLabel, value: "1"),
		]
		
		guard let url = components?.url else {
			return nil
		}
		
		return buildAuthenticatedRequest(with: url, method: .get)
	}
	
	static func buildGetBreedImageRequest(
		imageId: String
	) -> URLRequest? {
		
		guard let url = URLComponents(string: "\(baseURL)/images/\(imageId)")?.url else {
			return nil
		}
		
		return buildAuthenticatedRequest(with: url, method: .get)
	}
	
	static func buildGetImageRequest(
		from urlString: String
	) -> URLRequest? {
		guard let url = URL(string: urlString) else {
			return nil
		}
		
		return buildAuthenticatedRequest(with: url, method: .get)
	}
	
	static func buildGetFavoritesRequest(
		userId: String
	) -> URLRequest? {
		var components = URLComponents(string: "\(baseURL)/favourites")
		
		components?.queryItems = [
			URLQueryItem(name: apiQueryUserIdLabel, value: userId),
		]
		
		guard let url = components?.url else {
			return nil
		}
		
		return buildAuthenticatedRequest(with: url, method: .get)
	}
	
	static func buildPostFavoriteRequest(
		imageId: String,
		userId: String
	) -> URLRequest? {
		guard let url = URLComponents(string: "\(baseURL)/favourites")?.url,
			  let body = try? JSONEncoder().encode(AddFavoriteRequest(imageId: imageId, userId: userId)),
			  var request = buildAuthenticatedRequest(with: url, method: .post) else {
			return nil
		}
		
		print("raw body: \(String(describing: String(data: body, encoding: .utf8)))")
		
		request.httpBody = body
		
		return request
	}
	
	static func buildDeleteFavoriteRequest(
		favoriteId: Int
	) -> URLRequest? {
		guard let url = URLComponents(string: "\(baseURL)/favourites/\(favoriteId)")?.url else {
			return nil
		}
		
		return buildAuthenticatedRequest(with: url, method: .delete)
	}
	
	
	private static func buildAuthenticatedRequest(
		with url: URL,
		method: HTTPMethod
	) -> URLRequest? {
		guard let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String else {
			return nil
		}
		
		var request = URLRequest(url: url)
		request.httpMethod = method.rawValue
		
		request.setValue(apiKey, forHTTPHeaderField: apiKeyHeader)
		
		return request
	}
		
}


enum HTTPMethod: String {
	case get, post, put, delete
	
	var rawValue: String {
		switch self {
			case .get: "GET"
			case .post: "POST"
			case .put: "PUT"
			case .delete: "DELETE"
		}
	}
}
