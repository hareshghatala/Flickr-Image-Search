//
//  UIImageView+WebImage.swift
//  Flickr Image Search
//
//  Created by Haresh Ghatala on 2021/08/30.
//

import Foundation
import UIKit

class ImageCache {

    let cache = NSCache<NSString, UIImage>()
    
    public static let shared = ImageCache()
    private init() {}
    
}

extension UIImageView {
    
    func load(urlStr: String, placeholder: Bool = true) {
        
        if let cachedImage = ImageCache.shared.cache.object(forKey: urlStr as NSString) {
            self.image = cachedImage
            return
        }
        
        self.image = placeholder ? UIImage(systemName: "photo") : UIImage()
        
        guard let url = URL(string: urlStr) else { return }
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    ImageCache.shared.cache.setObject(image, forKey: urlStr as NSString)
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
        
    }
    
}
