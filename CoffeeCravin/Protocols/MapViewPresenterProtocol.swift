//
//  MapViewPresenterProtocol.swift
//  CoffeeCravin
//
//  Created by George Cremer on 15/04/2021.
//

import Foundation
import MapKit

protocol MapViewPresenterProtocol: AnyObject {
    init(coffeeLocationNetworkManager: CoffeeLocationNetworkManagerProtocol, networkDelegate: CoffeeLocationNetworkManagerDelegate, menuDelegate: MenuDelegate)
    func findCoffeeShops(latitude: Double, longitude: Double)
}
