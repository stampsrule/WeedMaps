//
//  APIController.swift
//  WeedmapsChallenge
//
//  Created by Daniel Bell on 4/27/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import Foundation
//import CoreLocation

class APIController: NSObject {
    
    static public var locationManager = LocationController()
    
    public static func config() -> URLSessionConfiguration {
        let apiKey = "kTeDzH1GDKgBrdmpLeXU0XgykOfS0dbGStVj-uls8eVhvpjvInTMxUnxM0f4-xb49sODZx2qJNcRc-CLuwKGlyqUgc85tqDPwy5lCMKPQyEKMuEoHuY4G0tYCCjCXHYx"
        
        let config = URLSessionConfiguration.default
        
        var headers = [String: String]()
        headers["Content-Type"] = "application/json"
        headers["Authorization"] = "Bearer " + apiKey
        
        config.httpAdditionalHeaders = headers
        config.networkServiceType = NSURLRequest.NetworkServiceType.default
        return config
    }

    public static func createURL(path: String, queryItems: [URLQueryItem]) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.yelp.com"
        components.path = "/v3/" + path
        
        var localQueryItems = queryItems
        localQueryItems.append(URLQueryItem(name: "locale", value: LanguageController.localizationIdenifier))
        components.queryItems = localQueryItems
        
        return components.url
    }
}

