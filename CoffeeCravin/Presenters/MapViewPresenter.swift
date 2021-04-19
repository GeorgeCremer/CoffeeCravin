//
//  MapViewPresenter.swift
//  CoffeeCravin
//
//  Created by George Cremer on 15/04/2021.
//

import Foundation

class MapViewPresenter: MapViewPresenterProtocol {
    private var coffeeLocationNetworkManager: CoffeeLocationNetworkManagerProtocol!
    private weak var networkDelegate: CoffeeLocationNetworkManagerDelegate?

    required init(coffeeLocationNetworkManager: CoffeeLocationNetworkManagerProtocol, networkDelegate: CoffeeLocationNetworkManagerDelegate) {
        self.coffeeLocationNetworkManager = coffeeLocationNetworkManager
        self.networkDelegate = networkDelegate
    }

    func findCoffeeShops(latitude: Double, longitude: Double) {
        coffeeLocationNetworkManager.getNearbyCoffeeLocations(latitude: latitude, longitude: longitude) { result in
            switch result {
            case let .success(result):
                self.networkDelegate?.successfullyRetrievedCoffeeShops(coffeeShops: result)

            case let .failure(error):
                self.networkDelegate?.errorHandler(error: error)
            }
        }
    }
}
