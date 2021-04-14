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

    override func viewDidLoad() {
        super.viewDidLoad()
        configMapView()
        configLocationManager()
        configureCoffeeSearchButton()
    }

    func configLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestLocation()
        locationManager.requestWhenInUseAuthorization()
    }

    func configMapView() {
        mapView.delegate = self
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

        NetworkManager.shared.getNearbyCoffeeLocations(latitude: centreCoordinates.latitude, longitude: centreCoordinates.longitude) { [self] result in
            switch result {
            case let .success(result):
                mapView.addCoffeeLocations(coffeeShops: result)

            case let .failure(error):
                // TODO:
                print(error)
            }
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_: CLLocationManager, didUpdateLocations _: [CLLocation]) {
//        currentLocation = locations[0].coordinate
    }

    func locationManager(_: CLLocationManager, didFailWithError _: Error) {}
}
