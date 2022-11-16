//
//  NumberFormatter+.swift
//  Citadele-test
//
//  Created by Pavels Vetlugins on 16/11/2022.
//

import Foundation

class CurrencyFormatter {
    static var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.usesGroupingSeparator = false
        return numberFormatter
    }()

    static func asCurrency(price: Double) -> String? {
        return numberFormatter.string(from: price as NSNumber)
    }
}
