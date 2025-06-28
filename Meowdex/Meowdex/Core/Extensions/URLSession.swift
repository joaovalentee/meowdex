//
//  URLSession.swift
//  Meowdex
//
//  Created by Johnnie on 28/06/2025.
//

import Foundation
import OSLog

fileprivate let logger = Logger(subsystem: "Meowdex", category: "URLSession")

/// HTTP valid request codes
fileprivate let validStatus = 200...299

extension URLSession {
	func get<T: Decodable>(for request: URLRequest) async throws -> T {
		logger.log("Getting data from \(String(describing: request.url))")
		return try await requestHandler {
			guard let (data, response) = try await self.data(for: request, delegate: nil) as? (Data, HTTPURLResponse) else {
				throw MeowError.networkError(.generalError)
			}
			
			/// Checking for cancellation after the request to ensure that we still need this information after the waiting time for the response.
			try Task.checkCancellation()
			
			guard validStatus.contains(response.statusCode) else {
				let responseBody = String(data: data, encoding: .utf8)
				logger.error("Request failed: \(response.statusCode), Body: \(String(describing: responseBody))")
				throw MeowError.networkError(.serverError)
			}
			
			let decoder = JSONDecoder()
			let parsed = try decoder.decode(T.self, from: data)
			
			logger.debug("Parsed data \(String(describing: parsed))")
			
			return parsed
		}
	}
	
	func post<Response: Decodable>(
		to request: URLRequest
	) async throws -> Response {
		logger.log("Posting data to \(String(describing: request.url))")
		
		var request = request
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		
		return try await requestHandler {
			guard let (data, response) = try await self.data(for: request) as? (Data, HTTPURLResponse) else {
				throw MeowError.networkError(.generalError)
			}
			
			/// Checking for cancellation after the request to ensure that we still need this information after the waiting time for the response.
			try Task.checkCancellation()
			
			guard validStatus.contains(response.statusCode) else {
				let responseBody = String(data: data, encoding: .utf8)
				logger.error("Request failed: \(response.statusCode), Body: \(String(describing: responseBody))")
				throw MeowError.networkError(.serverError)
			}
			
			let decoded = try JSONDecoder().decode(Response.self, from: data)
			return decoded
		}
	}
	
	func delete<Response: Decodable>(
		for request: URLRequest
	) async throws -> Response {
		return try await requestHandler {
			let (data, response) = try await self.data(for: request)
			
			guard let response = response as? HTTPURLResponse else {
				throw MeowError.networkError(.generalError)
			}
			
			guard validStatus.contains(response.statusCode) else {
				let responseBody = String(data: data, encoding: .utf8)
				logger.error("Request failed: \(response.statusCode), Body: \(String(describing: responseBody))")
				throw MeowError.networkError(.serverError)
			}
			
			let decoded = try JSONDecoder().decode(Response.self, from: data)
			return decoded
		}
	}
	
	private func requestHandler<T: Decodable>(
		block: @escaping () async throws -> T
	) async throws -> T {
		do {
			return try await block()
		} catch let error as URLError {
			logger.warning("Failed with no internet error \(error)")
			throw MeowError.noInternetConnection
		} catch let error as CancellationError {
			logger.warning("Failed with CancellationError")
			throw error
		} catch let error as DecodingError {
			logger.warning("Failed to parse data \(error)")
			throw MeowError.parseError
		} catch {
			logger.warning("Failed to get data with unknown error \(error.localizedDescription)")
			throw MeowError.generic(error)
		}
	}
}

enum MeowError: Error {
	case networkError(NetworkError)
	case noInternetConnection
	case parseError
	case generic(Error)
}

enum NetworkError : Error {
	case noAPIKey
	case serverError
	case generalError
	case badURL
}
