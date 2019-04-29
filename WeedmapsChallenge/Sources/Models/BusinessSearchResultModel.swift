//
//  BusinessSearchResultModel.swift
//  WeedmapsChallenge
//
//  Created by Daniel Bell on 4/27/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import Foundation

struct Coffeebusinesses: Codable {
    let businesses: [Business]?
    let total: Int?
    let region: Region?
}

struct Category: Codable {
    let alias, title: String?
}

struct Center: Codable {
    let latitude, longitude: Double?
}

struct Location: Codable {
    let address1: String?
    let address2, address3: String?
    let city: String?
    let zipCode: String?
    let country: String?
    let state: String?
    let displayAddress: [String]?
    
    enum CodingKeys: String, CodingKey {
        case address1, address2, address3, city
        case zipCode = "zip_code"
        case country, state
        case displayAddress = "display_address"
    }
}

struct Region: Codable {
    let center: Center?
}
