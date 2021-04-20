//
//  File.swift
//  CoffeeCravin
//
//  Created by George Cremer on 20/04/2021.
//

import CoreLocation

class CCLocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = CCLocationManager()
    private var locationManager = CLLocationManager()

    override private init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestLocation()
        locationManager.requestWhenInUseAuthorization()
    }

    func getDistanceFromUserLocationFormatted(to location: CLLocation) -> String? {
        guard let distanceInMeters = locationManager.location?.distance(from: location).rounded() else { return nil }
        if distanceInMeters >= 1000 {
            let km = distanceInMeters / 1000
            if km <= 10 {
                return "\(km.rounded(toPlaces: 1)) km"
            } else {
                return "\(Int(km)) km"
            }
        }
        return "\(Int(distanceInMeters)) meters"
    }

    func locationManager(_: CLLocationManager, didUpdateLocations _: [CLLocation]) {}

    func locationManager(_: CLLocationManager, didFailWithError _: Error) {}
}
