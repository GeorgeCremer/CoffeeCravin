
//
//  MockMapViewPresenter.swift
//  CoffeeCravinTestIng
//
//  Created by George Cremer on 20/04/2021.
//

@testable import CoffeeCravin
import Foundation

class MockMapViewPresenter: MapViewPresenterProtocol {
    var findCoffeeShops: Bool = false

    required init(coffeeLocationNetworkManager _: CoffeeLocationNetworkManagerProtocol, networkDelegate _: CoffeeLocationNetworkManagerDelegate, menuDelegate _: MenuDelegate) {
        // TODO:
    }

    func findCoffeeShops(latitude _: Double, longitude _: Double) {
        findCoffeeShops = true
    }
}
