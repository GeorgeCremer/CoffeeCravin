//
//  MapViewControllerTests.swift
//  CoffeeCravinTestIng
//
//  Created by George Cremer on 20/04/2021.
//

@testable import CoffeeCravin
import XCTest

class MapViewControllerTests: XCTestCase {
    var storyboard: UIStoryboard!
    var sut: MapViewController!

    override func setUpWithError() throws {
        storyboard = UIStoryboard(name: "Main", bundle: nil)
        sut = storyboard.instantiateViewController(identifier: "MapViewController") as? MapViewController
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        storyboard = nil
        sut = nil
    }

    func testMapViewControllerTests_coffeeSearchButtonTapped_InvokesSignupProcess() throws {
        let coffeeSearchButton: CCGetCoffeeButton = try XCTUnwrap(sut.coffeeSearchButton, "coffeeSearchButton is not connected")
        let coffeeSearchButtonActions = try XCTUnwrap(coffeeSearchButton.actions(forTarget: sut, forControlEvent: .touchUpInside), "coffeeSearchButton is not attached to an action")

        XCTAssertEqual(coffeeSearchButtonActions.count, 1, "Expected only one action assigned coffeeSearchButton, received \(coffeeSearchButtonActions.count)")
        XCTAssertEqual(coffeeSearchButtonActions.first, "coffeeSearchButtonTapped", "There is no action with the name coffeeSearchButtonTapped: assigned to the coffeeSearchButton")
    }

    func testMapViewControllerTests_WhenCreated_HasFindCoffeeShopsButtonAndAction() throws {
        let coffeeLocationNetworkManager = MockCoffeeLocationNetworkManager()
        let networkDelegate = MockNetworkDelegate()
        let menuDelegate = MockMenuDelegate()

        let mockMapViewPresenter = MockMapViewPresenter(coffeeLocationNetworkManager: coffeeLocationNetworkManager, networkDelegate: networkDelegate, menuDelegate: menuDelegate)
        sut.mapViewPresenter = mockMapViewPresenter
        sut.coffeeSearchButton.sendActions(for: .touchUpInside)
        XCTAssertTrue(mockMapViewPresenter.findCoffeeShops, "findCoffeeShops was not called on the presenter object when coffeeSearchButton was tapped in the MapViewController")
    }
}
