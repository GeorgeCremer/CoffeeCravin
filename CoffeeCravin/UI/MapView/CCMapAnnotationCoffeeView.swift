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
        configurePin()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var coffeePin: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = Images.coffeePin
        imageView.clipsToBounds = true
        return imageView
    }()

    private func configurePin() {
        image = Images.coffeePin
        frame = CGRect(x: 0, y: 0, width: 50, height: 50)
    }
}
