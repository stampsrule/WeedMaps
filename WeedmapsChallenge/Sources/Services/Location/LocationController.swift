//
//  LocationController.swift
//  WeedmapsChallenge
//
//  Created by Daniel Bell on 4/27/19.
//  Copyright © 2019 Weedmaps, LLC. All rights reserved.
//

import Foundation
import CoreLocation

class LocationController: NSObject {
    private var locationManager: CLLocationManager?
    public var longitude: CLLocationDegrees?
    public var latitude: CLLocationDegrees?

    override init() {
        super.init()
        if locationManager == nil && CLLocationManager.locationServicesEnabled(){
            locationManager = CLLocationManager()
            locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
            locationManager?.delegate = self
            
            locationAuthorized()
        }
    }
    
    func locationAuthorized() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            locationManager?.startUpdatingLocation()
            if let currentLocation = locationManager?.location?.coordinate {
                longitude = currentLocation.longitude
                latitude = currentLocation.latitude
            }
        case .notDetermined:
            locationManager?.requestWhenInUseAuthorization()
        case .restricted:
            //throw network error
            break
        case .denied:
            //throw network error
            break
        case .authorizedAlways:
            fatalError("UNEXPECTED: in always Authorized state")
        }
    }
    
}

extension LocationController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        longitude = currentLocation.coordinate.longitude
        latitude = currentLocation.coordinate.latitude
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationAuthorized()
    }
}
