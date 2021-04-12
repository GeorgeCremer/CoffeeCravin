//
//  MapViewController.swift
//  CoffeeCravin
//
//  Created by George Cremer on 12/04/2021.
//

import MapKit
import UIKit

class MapViewController: UIViewController {
    @IBOutlet var mapView: MKMapView!
    var coffeeSearchButton: CCGetCoffeeButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureCoffeeSearchButton()
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
        NetworkManager.shared.getNearbyCoffeeLocations { result in
            switch result {
            case .success(let result):
                // TODO
                print("NetworkManager.shared.getNearbyCoffeeLocations: SUCCESS")
                
            case .failure(let error):
                // TODO

                print(error)
            }
        }
    }
}
