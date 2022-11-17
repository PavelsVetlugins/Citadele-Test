//
//  RateCalculatorTest.swift
//  Citadele-testTests
//
//  Created by Pavels Vetlugins on 17/11/2022.
//

@testable import Citadele_test
import XCTest

final class RateCalculatorTest: XCTestCase {
    func testRateCalculations() throws {
        var calculator = RateCalculator(sellRate: 1.485, buyRate: 1.585, isSelling: false, isReverseUsdQuot: false, isUSDCurrency: false)
        var result = calculator.calculateRate(amount: 10)
        XCTAssertEqual(result, "15.85")

        calculator = RateCalculator(sellRate: 1.485, buyRate: 1.585, isSelling: true, isReverseUsdQuot: true, isUSDCurrency: true)
        result = calculator.calculateRate(amount: 10)
        XCTAssertEqual(result, "15.85")

        calculator = RateCalculator(sellRate: 1.485, buyRate: 1.585, isSelling: true, isReverseUsdQuot: true, isUSDCurrency: false)
        result = calculator.calculateRate(amount: 10)
        XCTAssertEqual(result, "6.73")

        calculator = RateCalculator(sellRate: 1.485, buyRate: 1.585, isSelling: true, isReverseUsdQuot: false, isUSDCurrency: false)
        result = calculator.calculateRate(amount: 10)
        XCTAssertEqual(result, "6.73")

        calculator = RateCalculator(sellRate: 1.485, buyRate: 1.585, isSelling: false, isReverseUsdQuot: true, isUSDCurrency: true)
        result = calculator.calculateRate(amount: 10)
        XCTAssertEqual(result, "6.73")
    }
}
