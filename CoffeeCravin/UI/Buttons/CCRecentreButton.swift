//
//  CCRecentreButton.swift
//  CoffeeCravin
//
//  Created by George Cremer on 16/04/2021.
//

import UIKit

class CCRecenterButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        setImage(Images.recenterEnabled, for: .normal)
        setImage(Images.recenterDisabled, for: .disabled)
        imageView?.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        translatesAutoresizingMaskIntoConstraints = false
    }
}
