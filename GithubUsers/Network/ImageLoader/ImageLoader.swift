//
//  ImageLoader.swift
//  GithubUsers
//
//  Created by mohamed tahoon on 11/11/2024.
//

import Foundation
import SwiftUI
import UIKit

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private let cache = NSCache<NSURL, UIImage>()
    
    func loadImage(from url: URL) {
        if let cachedImage = cache.object(forKey: url as NSURL) {
            self.image = cachedImage
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let image = UIImage(data: data) else {
                return
            }
            self.cache.setObject(image, forKey: url as NSURL)
            DispatchQueue.main.async {
                self.image = image
            }
        }.resume()
    }
}
