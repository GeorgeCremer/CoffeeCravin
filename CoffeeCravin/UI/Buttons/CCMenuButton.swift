//
//  CCMenuButton.swift
//  CoffeeCravin
//
//  Created by George Cremer on 20/04/2021.
//

import UIKit

class CCMenuButton: UIButton {
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
        setImage(CCImages.menu, for: .normal)
        imageView?.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        imageView?.tintColor = .systemPink
        layer.backgroundColor = UIColor.white.cgColor
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
    }
}
