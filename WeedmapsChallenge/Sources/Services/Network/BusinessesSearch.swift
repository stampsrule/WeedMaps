//
//  BusinessesSearch.swift
//  WeedmapsChallenge
//
//  Created by Daniel Bell on 4/27/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import Foundation
//-
//Cache search queries to disk and
//display past caches queries.
//The caching mechanism is up to you, just be sure that you can justify your reasoning for using a specific approach.

class BusinessesSearch: NSObject {
    
    private var task: URLSessionDataTask?
    private let MAXRESULTS = 1000
    public var offset = 1
    private var offsetString: String {
        return "\(offset)"
    }
    static var totalListings: Int?
    
    func stop() {
        task?.cancel()
    }
    
    func generateQueryItemsForBusinessSearch(term: String, newSearch: Bool, nextPage: Bool) -> [URLQueryItem] {
        if newSearch {
            offset = 1
        } else {
            offset += nextPage ? 15 : 0
        }
        
        var queryItems = [
            URLQueryItem(name: "term", value: term),
            URLQueryItem(name: "limit", value: "15"),
            URLQueryItem(name: "offset", value: offsetString)
        ]
        
        if let latitude = APIController.locationManager.latitude, let longitude = APIController.locationManager.longitude {
            queryItems.append(contentsOf: [
                URLQueryItem(name: "latitude", value: String(format:"%f", latitude)),
                URLQueryItem(name: "longitude", value:String(format:"%f", longitude))
                ])
        }
        //throw network error if lat long are not set
        return queryItems
    }
    
    
    func get(query: String, newSearch: Bool = false, nextPage: Bool = false, completion: @escaping ((Result<[Business]?>) -> Void)) {
        
        if let totalListings = BusinessesSearch.totalListings, nextPage, (offset + 15) > totalListings, (offset + 15) > MAXRESULTS {
            completion(Result<[Business]?>.failure("reched end of results"))
        }
        
        let session = URLSession(configuration: APIController.config())
        
        guard let url = APIController.createURL(path: "businesses/search", queryItems: generateQueryItemsForBusinessSearch(term: query, newSearch: newSearch, nextPage: nextPage)) else {
            fatalError("url info is wrong please check and validate")
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        task?.cancel()
        
        task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            guard error == nil else {
                print(error!)
                return
            }
            
            var result: Result<[Business]?>? = nil
            
            if let data = data, let searchResult = try? JSONDecoder().decode(Coffeebusinesses.self, from: data) {
                BusinessesSearch.totalListings = searchResult.total
                result = .success(searchResult.businesses)
            } else {
                result = .failure("Could not process data")
            }
            if let finishedResult = result {
                completion(finishedResult)
            }
        })
        task?.resume()
    }
}
