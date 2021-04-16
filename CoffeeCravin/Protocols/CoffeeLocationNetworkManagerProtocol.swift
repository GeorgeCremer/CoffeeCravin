//
//  MapViewDelegateProtocol.swift
//  CoffeeCravin
//
//  Created by George Cremer on 15/04/2021.
//

import Foundation

protocol CoffeeLocationNetworkManagerDelegate: AnyObject {
    func successfullyRetrievedCoffeeShops(coffeeShops: [CoffeeShopsModel])
    func errorHandler(error: CCErrors)

}
