//
//  CCMapViewDelegate.swift
//  CoffeeCravin
//
//  Created by George Cremer on 16/04/2021.
//

import CoreLocation

protocol CCMapViewDelegate: AnyObject {
    func mapViewCenterCoordinatesDidChange(coordinates: CLLocationCoordinate2D)
}
