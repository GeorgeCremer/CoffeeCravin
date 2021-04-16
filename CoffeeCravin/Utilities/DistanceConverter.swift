//
//  DistanceConverter.swift
//  CoffeeCravin
//
//  Created by George Cremer on 15/04/2021.
//

import Foundation

struct DistanceFormatter {
    func convert(distance: Measurement<UnitLength>) -> String {
        let distanceInMeters = distance.converted(to: .meters).value.rounded()
        if distanceInMeters >= 1000 {
            let km = distance.converted(to: .kilometers).value.rounded(toPlaces: 1)
            if km <= 10 {
                return "\(km) km"
            } else {
                return "\(Int(km)) km"
            }
        }
        return "\(Int(distanceInMeters)) meters"
    }
}
