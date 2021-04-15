//
//  MapViewPresenter.swift
//  CoffeeCravin
//
//  Created by George Cremer on 15/04/2021.
//

import Foundation

class MapViewPresenter: MapViewPresenterProtocol {
    private var coffeeLocationNetworkManager: CoffeeLocationNetworkManagerProtocol!
    private weak var delegate: MapViewDelegate?

    required init(coffeeLocationNetworkManager: CoffeeLocationNetworkManagerProtocol, delegate: MapViewDelegate) {
        self.coffeeLocationNetworkManager = coffeeLocationNetworkManager
        self.delegate = delegate
    }

    func findCoffeeShops(latitude: Double, longitude: Double) {
        coffeeLocationNetworkManager.getNearbyCoffeeLocations(latitude: latitude, longitude: longitude) { result in
            switch result {
            case let .success(result):
                self.delegate?.successfullyRetrievedCoffeeShops(coffeeShops: result)
            case let .failure(error):
                self.delegate?.errorHandler(error: error)
            }
        }
    }
}
