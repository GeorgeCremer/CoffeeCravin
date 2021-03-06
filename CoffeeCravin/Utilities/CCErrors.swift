//
//  CCErrors.swift
//  CoffeeCravin
//
//  Created by George Cremer on 12/04/2021.
//

import Foundation

enum CCErrors: String, Error, CaseIterable {
    case unableToCompleteNetworkRequest = "Unable to complete network request please check your internet connection"
    case unableToCompleteNetworkRequestURLError = "Unable to complete network request due to invalid URL"
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data received form the server was invalid. Please try again."
    case unableToRetrieveFourSquareAPIKeys = "Unable to retrieve API Keys"
    case couldntRetrieveCurrentLocation = "Unable to find your current location"
    case noCoffeeShopsNearby = "Sorry we couldn't find any coffee shops nearby, try a wider search?"
}
