//
//  CoffeeLocationNetworkManager.swift
//  CoffeeCravin
//
//  Created by George Cremer on 12/04/2021.
//

import Foundation

protocol CoffeeLocationNetworkManagerProtocol {
    func getNearbyCoffeeLocations(latitude: Double, longitude: Double, completed: @escaping (Result<[CoffeeShopsModel], CCErrors>) -> Void)
}

class CoffeeLocationNetworkManager: CoffeeLocationNetworkManagerProtocol {
    private enum FourSquareAPIKeys: String {
        case clientID
        case clientSecret
    }

    private var urlSession: URLSession

    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }

    func getNearbyCoffeeLocations(latitude: Double, longitude: Double, completed: @escaping (Result<[CoffeeShopsModel], CCErrors>) -> Void) {
        guard let clientID = retrieveFourSquareAPIKeys(for: .clientID) else {
            completed(.failure(.unableToRetrieveFourSquareAPIKeys))
            return
        }

        guard let clientSecret = retrieveFourSquareAPIKeys(for: .clientSecret) else {
            completed(.failure(.unableToRetrieveFourSquareAPIKeys))
            return
        }

        guard let url = constructCoffeeSearchURL(clientID: clientID, clientSecret: clientSecret, latitude: latitude, longitude: longitude) else {
            completed(.failure(.unableToCompleteNetworkRequestURLError))
            return
        }

        let task = urlSession.dataTask(with: url) { data, response, error in

            if let _ = error { completed(.failure(.unableToCompleteNetworkRequest)) }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }

            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }

            do {
                let json = try JSONDecoder().decode(FourSquareData.self, from: data)
                let dataArray = json.response.groups
                var coffeeShops: [CoffeeShopsModel] = []
                for result in dataArray {
                    result.items.forEach {
                        guard let name = $0.venue.name else { return }
                        guard let location = $0.venue.location else { return }
                        guard let lat = location.lat else { return }
                        guard let lng = location.lng else { return }
                        guard let distance = location.distance else { return }
                        guard let multiLineAddress = $0.venue.location?.formattedAddress else { return }

                        let address = self.formatAddress(for: multiLineAddress)
                        let isOpen = $0.venue.hours?.isOpen
                        let status = $0.venue.hours?.status
                        let rating = $0.venue.rating

                        let coffeeShop = CoffeeShopsModel(name: name, rating: rating, address: address, lat: lat, lng: lng, distance: distance, status: status, isOpen: isOpen)
                        coffeeShops.append(coffeeShop)
                    }
                }
                completed(.success(coffeeShops))

            } catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }

    private func constructCoffeeSearchURL(clientID: String, clientSecret: String, latitude: Double, longitude: Double) -> URL? {
        let baseURL = "https://api.foursquare.com/v2/"
        let searchType = "venues/explore"

        /// clientID ID + clientSecret

        let coordinates = "&ll=\(latitude),\(longitude)"
        let query = "&%20query=coffee%20%20"
        let filterForCafeCoffeeCategories = "&\(cafeCoffeeCategories())"
        let versionDate = "&v=20210401"

        let endpoint = baseURL + searchType + clientID + clientSecret + coordinates + query + filterForCafeCoffeeCategories + versionDate
        return URL(string: endpoint)
    }

    private func cafeCoffeeCategories() -> String {
        let coffeeRoaster = "5e18993feee47d000759b256"
        let gamingCafe = "4bf58dd8d48988d18d941735"
        let cafe = "4bf58dd8d48988d16d941735"
        let petCafe = "56aa371be4b08b9a8d573508"
        let corporateCoffeeShop = "5665c7b9498e7d8a4f2c0f06"
        return [coffeeRoaster, gamingCafe, cafe, petCafe, coffeeRoaster, corporateCoffeeShop].joined(separator: ",")
    }

    private func formatAddress(for addressFormatted: [String?]?) -> String {
        let emptyText = "Street address not found\nSee map location."
        guard let address = addressFormatted else { return emptyText }
        let filtered = address.compactMap { $0 }
        return filtered.isEmpty ? emptyText : filtered.joined(separator: "\n")
    }

    private func retrieveFourSquareAPIKeys(for api: FourSquareAPIKeys) -> String? {
        let key: String = api.rawValue
        var path: String!
        switch api {
        case .clientID:
            path = "?client_id="
        case .clientSecret:
            path = "&client_secret="
        }

        if let infoPlistPath = Bundle.main.path(forResource: "FourSquareCredentials", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: infoPlistPath) as? [String: String]
        {
            if let result = dict[key] {
                if !result.isEmpty {
                    return path.appending(result)
                }
            }
        }
        return nil
    }
}
