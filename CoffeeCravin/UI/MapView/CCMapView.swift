//
//  CCMapView.swift
//  CoffeeCravin
//
//  Created by George Cremer on 14/04/2021.
//

import MapKit
import UIKit

class CCMapView: MKMapView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    let locationManager = CCLocationManager.shared

    var displayedCoffeeShops: [MKAnnotation] = []

    func addCoffeeLocations(coffeeShops: [CoffeeShopsModel]) {
        var newAnnotations: [MKAnnotation] = []

        coffeeShops.forEach {
            let latitude = $0.lat
            let longitude = $0.lng
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            annotation.title = $0.name
            var subtitle = $0.address
            if let distance = locationManager.getDistanceFromUserLocationFormatted(to: CLLocation(latitude: latitude, longitude: longitude)) {
                subtitle.append("\n\(distance)")
            }
            annotation.subtitle = subtitle
            newAnnotations.append(annotation)
        }

        DispatchQueue.main.async { [self] in
            removeAnnotations(annotations)
            showAnnotations(newAnnotations, animated: true)
        }
    }
}
