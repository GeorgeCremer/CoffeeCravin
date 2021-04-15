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
    var locationManager: CLLocationManager!
    var currentLocation: CLLocationCoordinate2D?

    var mapViewPresenter: MapViewPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        if mapViewPresenter == nil {
            mapViewPresenter = MapViewPresenter(coffeeLocationNetworkManager: CoffeeLocationNetworkManager(), delegate: self)
        }

        configMapView()
        configLocationManager()
        configureCoffeeSearchButton()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(willTerminateNotification), name: UIApplication.willTerminateNotification, object: nil)
    }

    @objc func appMovedToBackground() {
        print("App moved to background!")
    }

    @objc func willTerminateNotification() {
        print("App moved to background!")
    }

    func configLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestLocation()
        locationManager.requestWhenInUseAuthorization()
    }

    func configMapView() {
        mapView.delegate = self
        mapView.register(CCMapAnnotationCoffeeView.self, forAnnotationViewWithReuseIdentifier: "coffeePin")
    }

    func configureCoffeeSearchButton() {
        let size: CGFloat = 60
        coffeeSearchButton = CCGetCoffeeButton(cornerRadius: size / 2)
        view.addSubview(coffeeSearchButton)

        NSLayoutConstraint.activate([
            coffeeSearchButton.heightAnchor.constraint(equalToConstant: size),
            coffeeSearchButton.widthAnchor.constraint(equalToConstant: size),
            coffeeSearchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            coffeeSearchButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),
        ])

        coffeeSearchButton.addTarget(self, action: #selector(coffeeSearchButtonTapped), for: .touchUpInside)
    }

    @objc func coffeeSearchButtonTapped() {
        print("coffeeSearchButtonTapped")
        let centreCoordinates = mapView.centerCoordinate
        mapViewPresenter?.findCoffeeShops(latitude: centreCoordinates.latitude, longitude: centreCoordinates.longitude)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_: CLLocationManager, didUpdateLocations _: [CLLocation]) {
//        currentLocation = locations[0].coordinate
    }

    func locationManager(_: CLLocationManager, didFailWithError _: Error) {}
}

extension MapViewController: MapViewDelegate {
    func successfullyRetrievedCoffeeShops(coffeeShops: [CoffeeShopsModel]) {
        print("successfullyRetrievedCoffeeShops MapViewDelegate: \(coffeeShops)")
        mapView.addCoffeeLocations(coffeeShops: coffeeShops)
    }

    func errorHandler(error: CCErrors) {
        print("errorHandler MapViewDelegate: \(error.rawValue)")
    }
}
