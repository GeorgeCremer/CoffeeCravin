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
    let baseURL = "https://api.foursquare.com/v2/"

    private init() {}

    func getNearbyCoffeeLocations(completed: @escaping(Result<[CoffeeShopsModel],CCErrors>) -> Void) {
      
        let searchType = "venues/search"
        guard let clientID = retrieveFourSquareAPIKeys(for: .clientID) else {
            completed(.failure(.unableToRetrieveFourSquareAPIKeys))
            return
        }
        
        guard let clientSecret = retrieveFourSquareAPIKeys(for: .clientSecret) else {
            completed(.failure(.unableToRetrieveFourSquareAPIKeys))
            return
            
        }
        
        let coordinates = "&ll=40.74224,-73.99386"
        let query = "&%20query=coffee%20%20"
        let fourSquareAPIVersionDate = "&v=20210401"

        let endpoint = baseURL + searchType + clientID + clientSecret + coordinates + query + fourSquareAPIVersionDate

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
                let dataArray = json.response.venues
                var coffeeShops: [CoffeeShopsModel] = []
                
                for item in dataArray {
                    let address = item.location.address             ?? "Street address not found - see map location"
                    guard let name = item.name                      else {return}
                    guard let lat = item.location.lat               else {return}
                    guard let lng = item.location.lng               else {return}
                    guard let distance = item.location.distance     else {return}

                    let coffeeShop = CoffeeShopsModel(name: name, address: address, lat: lat, lng: lng, distance: distance)
                    coffeeShops.append(coffeeShop)
                    print(coffeeShop)
                }
                
                completed(.success(coffeeShops))

            } catch {
                completed(.failure(.invalidData))
                print("JSON error: \(error)")
            }
        }

        // Start Network Call
        task.resume()
    }
    

    private func retrieveFourSquareAPIKeys(for api: FourSquareAPIKeys) -> String? {
        let key: String = api.rawValue
   
        if let infoPlistPath = Bundle.main.path(forResource: "KeysForDemoUnsafe", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: infoPlistPath) as? [String: String] {
            if let value = dict[key] {
                return value
            }
           
        }
        return nil
    }
}
