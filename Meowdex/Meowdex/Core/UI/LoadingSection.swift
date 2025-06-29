//
//  LoadingSection.swift
//  Meowdex
//
//  Created by Johnnie on 29/06/2025.
//

import SwiftUI

struct LoadingSection: View {
    var body: some View {
		Section {
			ProgressView()
				.tint(.primary)
				.frame(maxWidth: .infinity)
		}
		.listRowBackground(Color.clear)
		.listRowInsets(EdgeInsets())
    }
}

#Preview {
    LoadingSection()
}
