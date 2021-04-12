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
        // This would handle init via storyboard, which we aren't using.
        fatalError("init(coder:) has not been implemented")
    }

    convenience init(cornerRadius: CGFloat) {
        self.init(frame: .zero)
        layer.cornerRadius = cornerRadius
    }

    private func configure() {
        setImage(UIImage(named: "CoffeeButtonIcon"), for: .normal)
        layer.backgroundColor = UIColor.systemPink.cgColor
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
    }
}
