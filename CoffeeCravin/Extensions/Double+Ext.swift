//
//  Double+Ext.swift
//  CoffeeCravin
//
//  Created by George Cremer on 14/04/2021.
//

import Foundation

extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10, Double(places))
        let result = (self * divisor).rounded() / divisor

        return result
    }

    func roundedToNearest(to n: Int) -> Self {
        let n = Self(n)
        return (self / n).rounded() * n
    }
}
