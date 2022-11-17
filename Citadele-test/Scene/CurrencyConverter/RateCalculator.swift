//
//  RateCalculator.swift
//  Citadele-test
//
//  Created by Pavels Vetlugins on 17/11/2022.
//

import Foundation

struct RateCalculator {
    let sellRate: Double
    let buyRate: Double
    let isSelling: Bool
    let isReverseUsdQuot: Bool
    let isUSDCurrency: Bool

    func calculateRate(amount: Double) -> String {
        let rateValue: Double
        if isReverseUsdQuot, isUSDCurrency {
            rateValue = 1 / (isSelling ? buyRate : sellRate)
        } else {
            rateValue = isSelling ? sellRate : buyRate
        }

        if isSelling {
            return CurrencyFormatter.asCurrency(price: amount / rateValue) ?? ""
        } else {
            return CurrencyFormatter.asCurrency(price: amount * rateValue) ?? ""
        }
    }
}
