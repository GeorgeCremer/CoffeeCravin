//
//  FourSquareAPIModel.swift
//  CoffeeCravin
//
//  Created by George Cremer on 12/04/2021.
//

import Foundation

struct FourSquareData: Codable {
    var response: FourSquareVenues
}

struct FourSquareVenues: Codable {
    var venues: [FourSquareVenue]
}

struct FourSquareVenue: Codable {
    var name: String?
    var location: FourSquareVenueLocation
}

struct FourSquareVenueLocation: Codable {
    var address: String?
    var lat: Double?
    var lng: Double?
    var distance: Int?
}
