//
//  BreedImage.swift
//  Meowdex
//
//  Created by Johnnie on 29/06/2025.
//

import SwiftUI
import Kingfisher

struct BreedImage: View {
	
	let imageUrl: String?
	
    var body: some View {
		if let imageUrl,
		   let url = URL(string: imageUrl) {
			KFImage.url(url)
				.placeholder {
					ProgressView()
				}
				.loadDiskFileSynchronously()
				.fade(duration: 0.25)
				.onProgress { receivedSize, totalSize in  }
				.onSuccess { result in
					switch result.cacheType {
						case .memory, .disk:
							print("✅ Loaded from cache (\(result.cacheType))")
						case .none:
							print("🌐 Downloaded from the internet")
					}
				}
				.onFailure { error in }
				.resizable()
				.aspectRatio(contentMode: .fill)
				
		} else {
			RoundedRectangle.imageShape
				.fill(.secondary)
				.overlay {
					Image(systemName: "photo")
				}
		}
    }
}

#Preview {
    BreedImage(imageUrl: nil)
}
