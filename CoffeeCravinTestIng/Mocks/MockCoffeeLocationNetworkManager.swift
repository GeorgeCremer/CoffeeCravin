//
//  MockCoffeeLocationNetworkManager.swift
//  CoffeeCravinTestIng
//
//  Created by George Cremer on 20/04/2021.
//

@testable import CoffeeCravin
import Foundation

class MockCoffeeLocationNetworkManager: CoffeeLocationNetworkManagerProtocol {
    func getNearbyCoffeeLocations(latitude _: Double, longitude _: Double, completed _: @escaping (Result<[CoffeeShopsModel], CCErrors>) -> Void) {
        // TODO:
    }
}
