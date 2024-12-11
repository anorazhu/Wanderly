//
//  CityImageView.swift
//  Wanderly
//
//  Created by Anora Zhu on 12/11/24.
//

import SwiftUI

struct CityImageView: View {
    @State private var viewModel = CityImageViewModel()
    let cityName: String

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading photo for \(cityName)...")
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
                    .padding()
            } else if let photoURL = viewModel.photoURL {
                AsyncImage(url: URL(string: photoURL)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: 300)
                        .cornerRadius(10)
                        .padding()
                } placeholder: {
                    ProgressView()
                }
            } else {
                Text("No photo available.")
                    .foregroundStyle(.gray)
            }
        }
        .task {
            await viewModel.fetchPhoto(for: cityName)
        }
    }
}

#Preview {
    CityImageView(cityName: "Paris")
}
