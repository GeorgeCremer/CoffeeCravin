//
//  CoffeeLocationNetworkManagerTests.swift
//  CoffeeCravinTestIng
//
//  Created by George Cremer on 15/04/2021.
//

@testable import CoffeeCravin
import XCTest

class CoffeeLocationNetworkManagerTests: XCTestCase {
    var config: URLSessionConfiguration!
    var sut: CoffeeLocationNetworkManager!

    override func setUpWithError() throws {
        config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: config)
        sut = CoffeeLocationNetworkManager(urlSession: urlSession)
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testCoffeeLocationNetworkManager_WhenGivenSuccessfulResponse_ReturnSuccess() {
        let responseJSONData = FourSquareAPIStub().successfulResponse.data(using: .utf8)
        MockURLProtocol.loadingHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, responseJSONData, nil)
        }

        let myExpectation = expectation(description: "loading")

        sut.getNearbyCoffeeLocations(latitude: 51.509865, longitude: -0.118092) { result in
            switch result {
            case let .success(shops):
                XCTAssertTrue(shops.count == 4, "Expecting 4 CoffeeShop locations for successful getNearbyCoffeeLocations() - instead got \(shops.count).")

            case let .failure(error):
                XCTFail("getNearbyCoffeeLocations() expected a successful result, not error: \(error)")
            }

            myExpectation.fulfill()
        }
        wait(for: [myExpectation], timeout: 5)
    }

    func testCoffeeLocationNetworkManager_WhenStatusCodeNot200_ReturnError() {
        let responseJSONData = FourSquareAPIStub().successfulResponse.data(using: .utf8)

        MockURLProtocol.loadingHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 100, httpVersion: nil, headerFields: nil)!
            return (response, responseJSONData, nil)
        }

        let myExpectation = expectation(description: "loading")

        sut.getNearbyCoffeeLocations(latitude: 51.509865, longitude: -0.118092) { result in
            switch result {
            case .success:
                XCTFail("getNearbyCoffeeLocations() expected a error - returned successfully")

            case let .failure(error):
                XCTAssertEqual(error, CCErrors.invalidResponse, "getNearbyCoffeeLocations() expected error")
            }

            myExpectation.fulfill()
        }
        wait(for: [myExpectation], timeout: 5)
    }

    func testCoffeeLocationNetworkManager_WhenInvalidData_ReturnErrorInvalidData() {
        MockURLProtocol.loadingHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, Data(), nil)
        }

        let myExpectation = expectation(description: "loading")

        sut.getNearbyCoffeeLocations(latitude: 51.509865, longitude: -0.118092) { result in
            switch result {
            case .success:
                XCTFail("getNearbyCoffeeLocations() expected a error - returned successfully")

            case let .failure(error):
                XCTAssertEqual(error, CCErrors.invalidData, "getNearbyCoffeeLocations() expected error invalidData")
            }

            myExpectation.fulfill()
        }
        wait(for: [myExpectation], timeout: 5)
    }
}
