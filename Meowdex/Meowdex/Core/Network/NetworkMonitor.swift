//
//  NetworkMonitor.swift
//  Meowdex
//
//  Created by Johnnie on 29/06/2025.
//

import Network
import Observation
import SwiftUI

extension EnvironmentValues {
	@Entry var isNetworkConnected: Bool = true
}

@Observable
final class NetworkMonitor {
	static let shared = NetworkMonitor()
	
	private let monitor = NWPathMonitor()
	private let queue = DispatchQueue(label: "Network Monitor")
	
	private(set) var isConnected: Bool = true
	
	private init() {
		startMonitoring()
	}
	
	private func startMonitoring() {
		monitor.pathUpdateHandler = { [weak self] path in
			Task { @MainActor in
				self?.isConnected = path.status == .satisfied
			}
		}
		monitor.start(queue: queue)
	}
	
	func stopMonitoring() {
		monitor.cancel()
	}
}
