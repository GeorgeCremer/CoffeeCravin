//
//  NetworkManager.swift
//  CoffeeCravin
//
//  Created by George Cremer on 12/04/2021.
//

import Foundation

class NetworkManager {
    private enum FourSquareAPIKeys: String {
        case clientID
        case clientSecret
    }

    static let shared = NetworkManager()
    private let baseURL = "https://api.foursquare.com/v2/"

    private init() {}

    func getNearbyCoffeeLocations(latitude: Double, longitude: Double, completed: @escaping (Result<[CoffeeShopsModel], CCErrors>) -> Void) {
        guard let clientID = retrieveFourSquareAPIKeys(for: .clientID) else {
            completed(.failure(.unableToRetrieveFourSquareAPIKeys))
            return
        }

        guard let clientSecret = retrieveFourSquareAPIKeys(for: .clientSecret) else {
            completed(.failure(.unableToRetrieveFourSquareAPIKeys))
            return
        }

        let searchType = "venues/search"
        let coordinates = "&ll=\(latitude),\(longitude)"
        let query = "&query=coffee"
        let categoryIDCoffeeShop = "&categoryId=4bf58dd8d48988d1e0931735"
        let versionDate = "&v=20210401"

        let endpoint = baseURL + searchType + clientID + clientSecret + coordinates + query + categoryIDCoffeeShop + versionDate

        guard let url = URL(string: endpoint) else {
            completed(.failure(.unableToCompleteNetworkRequestURLError))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in

            if let _ = error {
                completed(.failure(.unableToCompleteNetworkRequest))
            }

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
                print(json)
                let dataArray = json.response.venues
                var coffeeShops: [CoffeeShopsModel] = []

                for result in dataArray {
                    let address = self.formatAddress(for: result.location.formattedAddress)
                    guard let name = result.name else { return }
                    guard let lat = result.location.lat else { return }
                    guard let lng = result.location.lng else { return }
                    guard let distance = result.location.distance else { return }

                    let coffeeShop = CoffeeShopsModel(name: name, address: address, lat: lat, lng: lng, distance: distance)
                    coffeeShops.append(coffeeShop)
                    print(coffeeShop)
                }
                completed(.success(coffeeShops))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        // Start Network Call
        task.resume()
    }

    private func formatAddress(for addressFormatted: [String?]?) -> String {
        let emptyText = "Street address not found\nSee map location."
        guard let address = addressFormatted else { return emptyText }
        let filtered = address.compactMap { $0 }
        return filtered.isEmpty ? emptyText : filtered.joined(separator: "\n")
    }

    private func retrieveFourSquareAPIKeys(for api: FourSquareAPIKeys) -> String? {
        let key: String = api.rawValue

        if let infoPlistPath = Bundle.main.path(forResource: "KeysForDemoUnsafe", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: infoPlistPath) as? [String: String]
        {
            if let value = dict[key] {
                return value
            }
        }
        return nil
    }
}
