//
//  MapViewController.swift
//  CoffeeCravin
//
//  Created by George Cremer on 12/04/2021.
//

import CoreLocation
import MapKit
import UIKit

class MapViewController: UIViewController {
    @IBOutlet var mapView: CCMapView!
    var coffeeSearchButton: CCGetCoffeeButton!
    var menuButton: CCMenuButton!
    var reCenterButton: CCRecenterButton!
    var mapViewPresenter: MapViewPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        configPresenter()
        configMapView()
        configButtons()
    }

    func configPresenter() {
        if mapViewPresenter == nil {
            mapViewPresenter = MapViewPresenter(coffeeLocationNetworkManager: CoffeeLocationNetworkManager(), networkDelegate: self, menuDelegate: self)
        }
    }

    func configMapView() {
        mapView.delegate = self
        mapView.register(CCMapAnnotationCoffeeView.self, forAnnotationViewWithReuseIdentifier: "coffeePin")
        mapView.setUserTrackingMode(.follow, animated: true)
    }

    func configButtons() {
        let size: CGFloat = 60
        let padding: CGFloat = 20

        menuButton = CCMenuButton(cornerRadius: size / 2)
        view.addSubview(menuButton)

        coffeeSearchButton = CCGetCoffeeButton(cornerRadius: size / 2)
        view.addSubview(coffeeSearchButton)

        reCenterButton = CCRecenterButton()
        view.addSubview(reCenterButton)

        NSLayoutConstraint.activate([
            menuButton.heightAnchor.constraint(equalToConstant: size),
            menuButton.widthAnchor.constraint(equalToConstant: size),
            menuButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            menuButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),

            coffeeSearchButton.heightAnchor.constraint(equalToConstant: size),
            coffeeSearchButton.widthAnchor.constraint(equalToConstant: size),
            coffeeSearchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            coffeeSearchButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),

            reCenterButton.heightAnchor.constraint(equalToConstant: size),
            reCenterButton.widthAnchor.constraint(equalToConstant: size),
            reCenterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            reCenterButton.bottomAnchor.constraint(equalTo: coffeeSearchButton.topAnchor, constant: -padding),
        ])

        menuButton.addTarget(self, action: #selector(menuButtonTapped), for: .touchUpInside)
        coffeeSearchButton.addTarget(self, action: #selector(coffeeSearchButtonTapped), for: .touchUpInside)
        reCenterButton.addTarget(self, action: #selector(reCenterButtonTapped), for: .touchUpInside)
    }

    @objc func menuButtonTapped() {
        presentAlertOnMainThread(title: "Menu", message: "What shall we do? 🤔", buttonTitle: "Random error generator", menuDelegate: self)
    }

    @objc func reCenterButtonTapped() {
        mapView.setUserTrackingMode(.follow, animated: true)
    }

    @objc func coffeeSearchButtonTapped() {
        let centreCoordinates = mapView.centerCoordinate
        mapViewPresenter?.findCoffeeShops(latitude: centreCoordinates.latitude, longitude: centreCoordinates.longitude)
    }
}

extension MapViewController: CoffeeLocationNetworkManagerDelegate {
    func successfullyRetrievedCoffeeShops(coffeeShops: [CoffeeShopsModel]) {
        mapView.addCoffeeLocations(coffeeShops: coffeeShops)
    }

    func errorHandler(error: CCErrors) {
        presentAlertOnMainThread(title: "Whoops 🤯", message: error.rawValue, buttonTitle: "OK", menuDelegate: nil)
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }
        let identifier = "coffeePin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? CCMapAnnotationCoffeeView
        if annotationView == nil {
            annotationView = CCMapAnnotationCoffeeView(annotation: annotation, reuseIdentifier: identifier)
        }
        annotationView?.setSubtitle(text: annotation.subtitle as? String)
        return annotationView
    }

    func mapView(_: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped _: UIControl) {
        guard let coordinate = view.annotation?.coordinate else { return }
        let appleURL = "http://maps.apple.com/?daddr=\(coordinate.latitude),\(coordinate.longitude)"
        UIApplication.shared.open(URL(string: appleURL)!, options: [:], completionHandler: nil)
    }
}

extension MapViewController: MenuDelegate {
    func generateRandomError() {
        let error = CCErrors.allCases.randomElement()!
        presentAlertOnMainThread(title: "Whoops 🤯", message: error.rawValue, buttonTitle: "OK", menuDelegate: nil)
    }
}
