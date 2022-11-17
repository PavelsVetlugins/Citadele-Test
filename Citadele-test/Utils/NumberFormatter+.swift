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
        numberFormatter.positiveFormat = "0.00"
        numberFormatter.negativeFormat = "-0.00"
        return numberFormatter
    }()

    static func asCurrency(price: Double) -> String? {
        return numberFormatter.string(from: price as NSNumber)
    }
}
