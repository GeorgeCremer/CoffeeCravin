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
        register(CCMapAnnotationCoffeeView.self, forAnnotationViewWithReuseIdentifier: "coffeePin")
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
            annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            annotation.title = $0.name
            annotation.subtitle = "\($0.address)\n\($0.distance) DISTANCE)"
            annotations.append(annotation)
        }

        DispatchQueue.main.async { [self] in
            addAnnotations(annotations)
            showAnnotations(annotations, animated: true)
        }
    }

    private func removeAnnotations() {
        DispatchQueue.main.async { [self] in
            removeAnnotations(annotations)
        }
    }

    func mapView(_: MKMapView, annotationView _: MKAnnotationView, calloutAccessoryControlTapped _: UIControl) {}
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "coffeePin"

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? CCMapAnnotationCoffeeView
        if annotationView == nil {
            annotationView = CCMapAnnotationCoffeeView(annotation: annotation, reuseIdentifier: "coffeePin")
        }
        annotationView!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapAnnotation)))
        annotationView!.canShowCallout = true
        annotationView!.calloutOffset = CGPoint(x: -5, y: 5)
        annotationView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)

        let label1 = UILabel()
        let subtitle = annotation.subtitle as? String
        label1.text = subtitle
        label1.numberOfLines = 0
        annotationView!.detailCalloutAccessoryView = label1

        return annotationView
    }

    @objc func didTapAnnotation() {
        print("didTapAnnotation")
    }

    func mapView(_: MKMapView, didDeselect view: MKAnnotationView) {
        if let annotationTitle = view.annotation?.title {
            print("User tapped on annotation with title: \(annotationTitle!)")
        }
    }

    func mapView(_: MKMapView, annotationView _: MKAnnotationView, calloutAccessoryControlTapped _: UIControl) {
        print("calloutAccessoryControlTapped")
    }

    func mapView(_: MKMapView, didSelect _: MKAnnotationView) {
        print("didSelectAnnotationTapped")
    }
}
