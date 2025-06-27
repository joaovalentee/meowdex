//
//  BreedListScreen.swift
//  Meowdex
//
//  Created by Johnnie on 27/06/2025.
//

import SwiftUI
import SwiftData

struct BreedListScreen: View {
	
	@Query(sort: \CatBreed.breed)
	private var breeds: [CatBreed]
	
	private func ImageShape() -> RoundedRectangle {
		return RoundedRectangle(cornerRadius: 18)
	}
	
    var body: some View {
		NavigationStack {
			List {
				ForEach(breeds) { breed in
					Button {
						
					} label: {
						HStack(spacing: 16) {
							AsyncImage(url: URL(string: breed.imageUrl)) { phase in
								if let image = phase.image {
									image
										.resizable()
										.aspectRatio(contentMode: .fill)
										.frame(width: 55, height: 55, alignment: .top)
										.clipShape(ImageShape())
								} else if phase.error != nil {
									ImageShape()
										.fill(.secondary)
										.frame(width: 55, height: 55, alignment: .top)
										.clipShape(ImageShape())
										.overlay {
											Image(systemName: "photo")
										}
								} else {
									ImageShape()
										.fill(.secondary)
										.overlay {
											ProgressView()
												.tint(.primary)
										}
								}
							}
							.frame(width: 55, height: 55)
							
							Text(breed.breed)
								.fontWeight(.semibold)
								.foregroundStyle(.primary)
							
							Spacer()
							
							BreedFavoriteButton(breed: breed)
								.font(.title2)
						}
					}
				}
			}
			.navigationTitle("Cat Breeds")
		}
    }
}

#Preview {
    BreedListScreen()
		.catBreedsDataContainerPreview(populateWith: CatBreed.preview)
}
