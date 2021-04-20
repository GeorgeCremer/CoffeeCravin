//
//  CCMenuButtonTests.swift
//  CoffeeCravinTestIng
//
//  Created by George Cremer on 20/04/2021.
//

@testable import CoffeeCravin
import XCTest

class CCMenuButtonTests: XCTestCase {
    var sut: CCMenuButton!

    override func setUpWithError() throws {
        sut = CCMenuButton()
    }

    override func tearDownWithError() throws {
        sut = nil
    }

    func testCCMenuButton_WhenCreatedWithCornerRadius_IsConfiguredCorrectly() throws {
        let cornerRadius: CGFloat = 16
        sut = CCMenuButton(cornerRadius: cornerRadius)
        let imageView = try XCTUnwrap(sut.imageView, "imageView has not been connected")
        XCTAssert(imageView.image == CCImages.menu, "imageView.image is not set correctly, expected CCImages.menu")
        XCTAssert(imageView.tintColor == UIColor.systemPink, "Icon tint colour is not set correctly, expected UIColor.systemPink")
        XCTAssert(sut.layer.cornerRadius == cornerRadius, "cornerRadius is not set correctly, expected \(cornerRadius)")
        XCTAssert(sut.layer.backgroundColor == UIColor.white.cgColor, "Background colour is not set correctly, expected UIColor.white.cgColor")
        XCTAssertTrue(sut.clipsToBounds, "clipsToBounds not set correctly, expected true")
        XCTAssertFalse(sut.translatesAutoresizingMaskIntoConstraints, "translatesAutoresizingMaskIntoConstraints not set correctly, expected false")
    }
}
