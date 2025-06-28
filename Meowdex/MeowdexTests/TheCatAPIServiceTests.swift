//
//  TheCatAPIServiceTests.swift
//  MeowdexTests
//
//  Created by Johnnie on 28/06/2025.
//

import Foundation
import Testing
@testable import Meowdex

/// Implemented tests:
/// - Build valid fetch breeds request: validates if the request to load paginated breed information is successfully created
/// - Build valid search breeds request: validates if the request to search for a specific breed by its name is successfully created
/// - Build valid fetch favorites request: validates if the request to load all favorite breeds is successfully created
/// - Build valid add favorite request: validates if the request to add a new favorite breed is successfully created
/// - Build valid delete favorite request: validates if the request to delete an existing favorite breed is successfully created
/// - Fetch paged breeds success: tests if loading the paged breeds information is successful
///
/// Missing critical tests:
/// - Fetch paged empty breeds success: tests if loading the last page (empty) breeds information is successful
/// - Fetch favorites success: tests if loading all favorite breeds is successful
/// - Add favorite success: tests if adding a new favorite breeds is successful
/// - Delete favorite success: tests if removing an existing favorite breeds is successful
/// - Failed request with no internet error
/// - Failed request with cancellation error
/// - Failed request with parse error
/// - Failed request with no data (generic error)
/// - Failed request with server error
@Suite
struct TheCatAPIServiceTests {
	
	@Test("Build valid fetch breeds request")
	func fetchBreedsValidRequest() async throws {
		let expectedURL = URL(string: "https://api.thecatapi.com/v1/breeds?page=0&limit=12")!
		let expectedHeaderKey = ApiConstants.apiKeyHeader
		let expectedAPIKey = Bundle.main.infoDictionary?["API_KEY"] as? String
		
		let request: URLRequest = try #require(ApiConstants.buildGetBreedsRequest(page: 0, limit: 12))
		
		// Verify URL
		#expect(request.url == expectedURL)
		
		// Verify HTTP Method
		#expect(request.httpMethod == "GET")
		
		// Verify headers
		let headerValue = request.value(forHTTPHeaderField: expectedHeaderKey)
		#expect(headerValue == expectedAPIKey)
	}
	
	@Test("Build valid search breeds request")
	func searchBreedsValidRequest() async throws {
		let expectedName = "air"
		let expectedURL = URL(string: "https://api.thecatapi.com/v1/breeds/search?q=\(expectedName)&attach_image=1")!
		let expectedHeaderKey = ApiConstants.apiKeyHeader
		let expectedAPIKey = Bundle.main.infoDictionary?["API_KEY"] as? String
		
		let request: URLRequest = try #require(ApiConstants.buildGetSearchBreedsRequest(name: expectedName))
		
		// Verify URL
		#expect(request.url == expectedURL)
		
		// Verify HTTP Method
		#expect(request.httpMethod == "GET")
		
		// Verify headers
		let headerValue = request.value(forHTTPHeaderField: expectedHeaderKey)
		#expect(headerValue == expectedAPIKey)
	}
	
	@Test("Build valid fetch favorites request")
	func fetchFavoritesValidRequest() async throws {
		let expectedUserId = "my-user-12345"
		let expectedURL = URL(string: "https://api.thecatapi.com/v1/favourites?sub_id=\(expectedUserId)")!
		let expectedHeaderKey = ApiConstants.apiKeyHeader
		let expectedAPIKey = Bundle.main.infoDictionary?["API_KEY"] as? String
		
		let request: URLRequest = try #require(ApiConstants.buildGetFavoritesRequest(userId: expectedUserId))
		
		// Verify URL
		#expect(request.url == expectedURL)
		
		// Verify HTTP Method
		#expect(request.httpMethod == "GET")
		
		// Verify headers
		let headerValue = request.value(forHTTPHeaderField: expectedHeaderKey)
		#expect(headerValue == expectedAPIKey)
	}
	
	@Test("Build valid add favorite request")
	func addFavoriteValidRequest() async throws {
		let expectedImageId = "7isAO4Cav"
		let expectedSubId = "my-user-12345"
		let expectedBody = try! JSONEncoder().encode(
			AddFavoriteRequest(imageId: expectedImageId, userId: expectedSubId)
		)
		let expectedURL = URL(string: "https://api.thecatapi.com/v1/favourites")!
		let expectedHeaderKey = ApiConstants.apiKeyHeader
		let expectedAPIKey = Bundle.main.infoDictionary?["API_KEY"] as? String
		
		let request: URLRequest = try #require(ApiConstants.buildPostFavoriteRequest(imageId: expectedImageId, userId: expectedSubId))
		
		// Verify URL
		#expect(request.url == expectedURL)
		
		// Verify HTTP Method
		#expect(request.httpMethod == "POST")
		
		#expect(request.httpBody == expectedBody)
		
		// Verify headers
		let headerValue = request.value(forHTTPHeaderField: expectedHeaderKey)
		#expect(headerValue == expectedAPIKey)
	}
	
	
	@Test("Build valid delete favorite request")
	func deleteFavoriteValidRequest() async throws {
		let expectedFavoriteId = 232538751
		let expectedURL = URL(string: "https://api.thecatapi.com/v1/favourites/\(expectedFavoriteId)")!
		let expectedHeaderKey = ApiConstants.apiKeyHeader
		let expectedAPIKey = Bundle.main.infoDictionary?["API_KEY"] as? String
		
		let request: URLRequest = try #require(ApiConstants.buildDeleteFavoriteRequest(favoriteId: expectedFavoriteId))
		
		// Verify URL
		#expect(request.url == expectedURL)
		
		// Verify HTTP Method
		#expect(request.httpMethod == "DELETE")
		
		// Verify headers
		let headerValue = request.value(forHTTPHeaderField: expectedHeaderKey)
		#expect(headerValue == expectedAPIKey)
	}
	
	
	@Test("Fetch paged breeds success")
	func fetchBreedsValidResponse() async throws {
		let json = """
		  [
		  {
		  "weight": {
		   "imperial": "7  -  10",
		   "metric": "3 - 5"
		  },
		  "id": "abys",
		  "name": "Abyssinian",
		  "cfa_url": "http://cfa.org/Breeds/BreedsAB/Abyssinian.aspx",
		  "vetstreet_url": "http://www.vetstreet.com/cats/abyssinian",
		  "vcahospitals_url": "https://vcahospitals.com/know-your-pet/cat-breeds/abyssinian",
		  "temperament": "Active, Energetic, Independent, Intelligent, Gentle",
		  "origin": "Egypt",
		  "country_codes": "EG",
		  "country_code": "EG",
		  "description": "The Abyssinian is easy to care for, and a joy to have in your home. They’re affectionate cats and love both people and other animals.",
		  "life_span": "14 - 15",
		  "indoor": 0,
		  "lap": 1,
		  "alt_names": "",
		  "adaptability": 5,
		  "affection_level": 5,
		  "child_friendly": 3,
		  "dog_friendly": 4,
		  "energy_level": 5,
		  "grooming": 1,
		  "health_issues": 2,
		  "intelligence": 5,
		  "shedding_level": 2,
		  "social_needs": 5,
		  "stranger_friendly": 5,
		  "vocalisation": 1,
		  "experimental": 0,
		  "hairless": 0,
		  "natural": 1,
		  "rare": 0,
		  "rex": 0,
		  "suppressed_tail": 0,
		  "short_legs": 0,
		  "wikipedia_url": "https://en.wikipedia.org/wiki/Abyssinian_(cat)",
		  "hypoallergenic": 0,
		  "reference_image_id": "0XYvRd7oD"
		   }
		  ]
		  """.data(using: .utf8)!
		
		MockURLProtocol.requestHandler = { request in
			// Simulate a valid response
			let response = HTTPURLResponse(
				url: request.url!,
				statusCode: 200,
				httpVersion: nil,
				headerFields: nil
			)!
			
			return (response, json)
		}
		
		let sut = TheCatAPIService(session: makeMockSession())
		
		// Act
		let breeds = try await sut.fetchBreeds(page: 0)
		
		// Asserts
		let breed = try #require(breeds.first)
		#expect(breed.id == "abys")
		#expect(breed.name == "Abyssinian")
		#expect(breed.temperament == "Active, Energetic, Independent, Intelligent, Gentle")
		#expect(breed.origin == "Egypt")
		#expect(breed.lifespan == "14 - 15")
		#expect(breed.description == "The Abyssinian is easy to care for, and a joy to have in your home. They’re affectionate cats and love both people and other animals.")
		#expect(breed.imageId == "0XYvRd7oD")
	}
	
	
}

extension TheCatAPIServiceTests {
	private func makeMockSession() -> URLSession {
		let config = URLSessionConfiguration.ephemeral
		config.protocolClasses = [MockURLProtocol.self]
		return URLSession(configuration: config)
	}
}
