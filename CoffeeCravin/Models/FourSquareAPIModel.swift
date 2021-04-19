//
//  FourSquareAPIModel.swift
//  CoffeeCravin
//
//  Created by George Cremer on 12/04/2021.
//

import Foundation

struct FourSquareData: Codable {
    var response: FourSquareResponse
}

struct FourSquareResponse: Codable {
    var groups: [FourSquareGroup]
}

struct FourSquareGroup: Codable {
    var items: [FourSquareGroupItem]
}

struct FourSquareGroupItem: Codable {
    let venue: FourSquareVenue
}

struct FourSquareVenue: Codable {
    var name: String?
    var location: FourSquareVenueLocation?
    let rating: Double?
    let hours: Hours?
}

struct FourSquareVenueLocation: Codable {
    var address: String?
    var lat: Double?
    var lng: Double?
    var distance: Int?
    var formattedAddress: [String]?
}

struct Hours: Codable {
    var status: String?
    var isOpen: Bool?
}
