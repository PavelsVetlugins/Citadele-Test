//
//  CurrateResponse.swift
//  Citadele-test
//
//  Created by Pavels Vetlugins on 16/11/2022.
//

import Foundation

protocol CurrencyPresentable: Identifiable {
    var id: String { get }
    var description: String { get }
}

struct CurrateResponse: Codable {
    let data: [Currency]
}

struct Currency: Codable, Identifiable, CurrencyPresentable {
    let id, description: String
    let reverseUsdQuot: Bool
    let rates: [Rate]
}

struct Rate: Codable, Identifiable, CurrencyPresentable {
    let currency, description: String
    let sellRate, buyRate, sellTransfer, buyTransfer: String?

    var id: String { currency }
}

extension Currency {
    static func empty() -> Currency {
        Currency(id: "", description: "", reverseUsdQuot: true, rates: [])
    }

    static func mock() -> Currency {
        Currency(id: "EUR", description: "Euro", reverseUsdQuot: true, rates: [Rate(currency: "USD", description: "US Dollar", sellRate: "1.222", buyRate: "1.111", sellTransfer: "1.3", buyTransfer: "1,25")])
    }
}

extension Rate {
    static func empty() -> Rate {
        Rate(currency: "", description: "", sellRate: "", buyRate: "", sellTransfer: "", buyTransfer: "")
    }
}

extension Rate {
    var currencyNumber: Decimal {
        Decimal(string: currency) ?? 0
    }
}
