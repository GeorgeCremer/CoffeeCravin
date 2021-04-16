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
    var reCenterButton: CCRecenterButton!

    var locationManager: CLLocationManager!
    var currentLocation: CLLocationCoordinate2D?

    var mapViewPresenter: MapViewPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        if mapViewPresenter == nil {
            mapViewPresenter = MapViewPresenter(coffeeLocationNetworkManager: CoffeeLocationNetworkManager(), networkDelegate: self)
        }

        configMapView()
        configLocationManager()
        configButtons()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
    }
    

    @objc func appMovedToBackground() {
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
        mapView.setUserTrackingMode(.follow, animated: true)
        
    }

    func configButtons() {
        let size: CGFloat = 60
        let padding: CGFloat = 20
       
        coffeeSearchButton = CCGetCoffeeButton(cornerRadius: size / 2)
        view.addSubview(coffeeSearchButton)
        
        reCenterButton = CCRecenterButton()
        view.addSubview(reCenterButton)

        NSLayoutConstraint.activate([
            coffeeSearchButton.heightAnchor.constraint(equalToConstant: size),
            coffeeSearchButton.widthAnchor.constraint(equalToConstant: size),
            coffeeSearchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            coffeeSearchButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60),

            reCenterButton.heightAnchor.constraint(equalToConstant: size),
            reCenterButton.widthAnchor.constraint(equalToConstant: size),
            reCenterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            reCenterButton.bottomAnchor.constraint(equalTo: coffeeSearchButton.topAnchor, constant: -padding),
       ])
        
        coffeeSearchButton.addTarget(self, action: #selector(coffeeSearchButtonTapped), for: .touchUpInside)
        reCenterButton.addTarget(self, action: #selector(reCenterButtonTapped), for: .touchUpInside)

    }

    
    @objc func reCenterButtonTapped() {
        reCenterButton.isEnabled.toggle()
        if !reCenterButton.isEnabled {
            mapView.setUserTrackingMode(.follow, animated: true)
        }
    }

    @objc func coffeeSearchButtonTapped() {
        print("coffeeSearchButtonTapped")
        let centreCoordinates = mapView.centerCoordinate
        mapViewPresenter?.findCoffeeShops(latitude: centreCoordinates.latitude, longitude: centreCoordinates.longitude)
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations[0].coordinate
        print("currentLocation: \(currentLocation)")
    }

    func locationManager(_: CLLocationManager, didFailWithError _: Error) {
        
    }
}

extension MapViewController: CoffeeLocationNetworkManagerDelegate {
 
    
    func successfullyRetrievedCoffeeShops(coffeeShops: [CoffeeShopsModel]) {
        print("successfullyRetrievedCoffeeShops MapViewDelegate: \(coffeeShops)")
        mapView.addCoffeeLocations(coffeeShops: coffeeShops)
    }

    func errorHandler(error: CCErrors) {
        print("errorHandler MapViewDelegate: \(error.rawValue)")
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
        
        // TODO: Refactor
        annotationView!.canShowCallout = true
        annotationView!.calloutOffset = CGPoint(x: -5, y: 5)
        
        let navButton = UIButton(type: .detailDisclosure)
        navButton.tintColor = .systemPink
        navButton.setImage(UIImage(systemName: "car.fill"), for: .normal)
        annotationView!.rightCalloutAccessoryView = navButton

        let subtitleLabel = UILabel()
        let subtitle = annotation.subtitle as? String
        subtitleLabel.font = UIFont.systemFont(ofSize: 15, weight: .light)
        subtitleLabel.text = subtitle
        subtitleLabel.numberOfLines = 0
        annotationView!.detailCalloutAccessoryView = subtitleLabel

        return annotationView
    }
    
     func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        guard let coordinate = view.annotation?.coordinate else {return}
        let appleURL = "http://maps.apple.com/?daddr=\(coordinate.latitude),\(coordinate.longitude)"
        UIApplication.shared.open(URL(string:appleURL)!, options: [:], completionHandler: nil)

 
     }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//        guard let current = currentLocation else {return}
//        let mapCenter = mapView.centerCoordinate
//
//        if current.latitude == mapCenter.latitude, current.longitude == mapCenter.longitude {
//            print("centerCoordinate MATCH - DISABLE BUTTON")
//            reCenterButton.isEnabled = false
//        } else {
//            print("centerCoordinate NOT EQUAL - ENABLE BUTTON")
//            reCenterButton.isEnabled = true
//        }
    }

    
    
}
