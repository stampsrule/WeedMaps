//
//  Copyright © 2018 Weedmaps, LLC. All rights reserved.
//

import Foundation


struct Business: Codable {
    let id, alias, name: String?
    
    
//    What image resolution options do you offer for business photos and user profile photos?
//    By default, we return the original full-sized resolution; we use 'o' for business photos from the Business Details endpoint and 'o' for user profile photos (image_url) in the Reviews endpoint. Here are the different resolutions we currently provide:
//    
//    'o' (original): Up to 1,000x1,000
//    'l' (large): Up to 600x400
//    'm' (medium): Up to 100x100
//    'ms' (medium square): 100x100
//    's' (small): Up to 40x40
//    'ss' (small square): 40x40
//    
    let imageURL: String?
    
    
    
    let isClosed: Bool?
    let url: String?
    let reviewCount: Int?
    let categories: [Category]?
    let rating: Double?
    let coordinates: Center?
    let transactions: [String]?
    let price: String?
    let location: Location?
    let phone, displayPhone: String?
    let distance: Double?
    
    enum CodingKeys: String, CodingKey {
        case id, alias, name
        case imageURL = "image_url"
        case isClosed = "is_closed"
        case url
        case reviewCount = "review_count"
        case categories, rating, coordinates, transactions, price, location, phone
        case displayPhone = "display_phone"
        case distance
    }
}
