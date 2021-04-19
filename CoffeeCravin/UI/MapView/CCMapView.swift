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

    func addCoffeeLocations(coffeeShops: [CoffeeShopsModel]) {
        removeAnnotations()
        var annotations: [MKPointAnnotation] = []
        coffeeShops.forEach {
            let latitude = $0.lat
            let longitude = $0.lng
            let annotation = MKPointAnnotation()
            let distance = DistanceFormatter().convert(distance: .init(value: Double($0.distance), unit: .meters))

            annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            annotation.title = $0.name
            annotation.subtitle = "\($0.address)\n\(distance)"
            annotations.append(annotation)
        }

        DispatchQueue.main.async { [self] in
            addAnnotations(annotations)
            showAnnotations(annotations, animated: true)
        }
    }

    func removeAnnotations() {
        DispatchQueue.main.async { [self] in
            removeAnnotations(annotations)
        }
    }
}
