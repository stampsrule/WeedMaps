//
//  Throttler.swift
//  WeedmapsChallenge
//
//  Created by Daniel Bell on 4/28/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import Foundation
//import UIKit

public class Throttler {
    
    private let queue: DispatchQueue = DispatchQueue.main
    
    private var job: DispatchWorkItem = DispatchWorkItem(block: {})
    private var previousRun: Date = Date.distantPast
    private var maxInterval: Double
    
    init(seconds: Double) {
        self.maxInterval = seconds
    }
    
    
    func throttle(block: @escaping () -> ()) {
        job.cancel()
        job = DispatchWorkItem(){ [weak self] in
            self?.previousRun = Date()
            block()
        }
        let delay = Date.second(from: previousRun) > maxInterval ? 0 : maxInterval
        queue.asyncAfter(deadline: .now() + Double(delay), execute: job)
    }
}

private extension Date {
    static func second(from referenceDate: Date) -> Double {
        return Date().timeIntervalSince(referenceDate)
    }
}
