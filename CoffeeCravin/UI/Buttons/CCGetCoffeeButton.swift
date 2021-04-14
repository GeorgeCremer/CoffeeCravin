//
//  CCGetCoffeeButton.swift
//  CoffeeCravin
//
//  Created by George Cremer on 12/04/2021.
//

import UIKit

class CCGetCoffeeButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(cornerRadius: CGFloat) {
        self.init(frame: .zero)
        layer.cornerRadius = cornerRadius
    }

    private func configure() {
        setImage(Images.coffeeButtonIcon, for: .normal)
        layer.backgroundColor = UIColor.systemPink.cgColor
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
    }
}
