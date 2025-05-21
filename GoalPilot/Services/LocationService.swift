//
//  LocationService.swift
//  GoalPilot
//
//  Created by Rune Pollet on 16/05/2025.
//

import CoreLocation

class LocationService: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private var completion: ((CLLocation?) -> Void)?

    override init() {
        super.init()
        locationManager.delegate = self
    }

    func getLocation(completion: @escaping (CLLocation?) -> Void) {
        self.completion = completion
        
        // Request Authorization
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            return
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        default:
            completion(nil)
        }
    }

    // Delegate methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            completion?(location)
        } else {
            completion?(nil)
        }
        completion = nil
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        completion?(nil)
        completion = nil
    }
}
