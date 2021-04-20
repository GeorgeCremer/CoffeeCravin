//
//  MockNetworkDelegate.swift
//  CoffeeCravinTestIng
//
//  Created by George Cremer on 20/04/2021.
//

@testable import CoffeeCravin
import CoreLocation

class MockNetworkDelegate: CoffeeLocationNetworkManagerDelegate {
    func successfullyRetrievedCoffeeShops(coffeeShops _: [CoffeeShopsModel]) {
        // TODO:
    }

    func errorHandler(error _: CCErrors) {
        // TODO:
    }
}
