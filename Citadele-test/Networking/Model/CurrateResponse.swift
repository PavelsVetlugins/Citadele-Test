//
//  CurrateResponse.swift
//  Citadele-test
//
//  Created by Pavels Vetlugins on 16/11/2022.
//

import Foundation

struct CurrateResponse: Codable {
    let data: [Currency]
}

struct Currency: Codable, Identifiable {
    let id, description: String
    let reverseUsdQuot: Bool
    let rates: [Rate]
}

struct Rate: Codable {
    let currency, description: String
    let sellRate, buyRate, sellTransfer, buyTransfer: String?
}

extension Currency {
    static func mock() -> Currency {
        Currency(id: "EUR", description: "Euro", reverseUsdQuot: true, rates: [Rate(currency: "USD", description: "US Dollar", sellRate: "1.222", buyRate: "1.111", sellTransfer: "1.3", buyTransfer: "1,25")])
    }
}

extension Rate {
    var currencyNumber: Decimal {
        Decimal(string: currency) ?? 0
    }
}
