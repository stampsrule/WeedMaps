//
//  UIImage+URLLoader.swift
//
//  Copyright © 2019 DanielBell. All rights reserved.
//

import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    public func loadImage(from urlString: String) {
        
        guard let url = URL(string: urlString) else { return }
        
        loadImage(from: url)
    }
    
    public func loadImage(from url: URL) {
        
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: url.absoluteString as NSString) {
            self.image = imageFromCache
            return
        }
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, respones, error) in
            
            if error != nil {
                print(error ?? "")
                return
            }
            
            DispatchQueue.main.async {
                guard let data = data else { return }
                guard let imageToCache = UIImage(data: data) else { return }
                
                self.alpha = 0
                self.image = imageToCache
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.alpha = 1
                })
                
                
                imageCache.setObject(imageToCache, forKey: url.absoluteString as NSString)
            }
            
        }).resume()
    }
}
