//
//  MapViewPresenterProtocol.swift
//  CoffeeCravin
//
//  Created by George Cremer on 15/04/2021.
//

import Foundation

protocol MapViewPresenterProtocol: AnyObject {
    init(coffeeLocationNetworkManager: CoffeeLocationNetworkManagerProtocol, delegate: MapViewDelegate)
    func findCoffeeShops(latitude: Double, longitude: Double)
}
