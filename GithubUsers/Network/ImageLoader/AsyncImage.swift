//
//  AsyncImage.swift
//  GithubUsers
//
//  Created by mohamed tahoon on 11/11/2024.
//

import Foundation
import SwiftUI

struct AsyncImage: View {
    @StateObject private var loader = ImageLoader()
    private let url: URL?
    
    init(url: URL?) {
        self.url = url
    }
    
    var body: some View {
        if let image = loader.image {
            Image(uiImage: image)
                .resizable()
        } else {
            ProgressView()
                .onAppear {
                    if let url = url {
                        loader.loadImage(from: url)
                    }
                }
        }
    }
}
