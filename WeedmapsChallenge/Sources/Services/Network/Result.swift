//
//  Result.swift
//  WeedmapsChallenge
//
//  Created by Daniel Bell on 4/25/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case failure(String)
}
