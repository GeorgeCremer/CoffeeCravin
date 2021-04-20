//
//  MapCoffeePinView.swift
//  CoffeeCravin
//
//  Created by George Cremer on 14/04/2021.
//

import MapKit
import UIKit

class CCMapAnnotationCoffeeView: MKAnnotationView {
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        configure()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setSubtitle(text: String?) {
        let subtitleLabel = UILabel()
        subtitleLabel.font = UIFont.systemFont(ofSize: 15, weight: .light)
        subtitleLabel.text = text
        subtitleLabel.numberOfLines = 0
        detailCalloutAccessoryView = subtitleLabel
    }

    private func configure() {
        image = CCImages.coffeePin
        frame = CGRect(x: 0, y: 0, width: 50, height: 50)

        canShowCallout = true
        calloutOffset = CGPoint(x: -5, y: 5)

        let navButton = UIButton(type: .detailDisclosure)
        navButton.tintColor = .systemPink
        navButton.setImage(UIImage(systemName: "car.fill"), for: .normal)
        rightCalloutAccessoryView = navButton
    }
}
