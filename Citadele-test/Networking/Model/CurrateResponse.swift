//
//  CurrateResponse.swift
//  Citadele-test
//
//  Created by Pavels Vetlugins on 16/11/2022.
//

import Foundation

import Foundation

// MARK: - CurrateResponse

struct CurrateResponse: Codable {
    let data: [Currency]

//    enum CodingKeys: String, CodingKey {
//        case data
//    }
}

// MARK: - Datum

struct Currency: Codable {
    let id, description: String
    let reverseUsdQuot: Bool
    let rates: [Rate]

//    enum CodingKeys: String, CodingKey {
//        case id, description, reverseUsdQuot, rates
//    }
}

// MARK: - Rate

struct Rate: Codable {
    let currency, description: String
    let sellRate, buyRate, sellTransfer, buyTransfer: String?
}
