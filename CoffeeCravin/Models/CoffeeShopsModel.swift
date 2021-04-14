//
//  CoffeeShopsModel.swift
//  CoffeeCravin
//
//  Created by George Cremer on 12/04/2021.
//

import Foundation

struct CoffeeShopsModel: Codable {
    let name: String
    let address: String
    let lat: Double
    let lng: Double
    let distance: Int
}
