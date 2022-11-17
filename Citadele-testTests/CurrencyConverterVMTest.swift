//
//  CurrencyConverterVMTest.swift
//  Citadele-testTests
//
//  Created by Pavels Vetlugins on 17/11/2022.
//

@testable import Citadele_test
import Combine
import XCTest

final class CurrencyConverterVMTest: XCTestCase {
    func testSelectingCurrrenctWillSetChildRate() throws {
        let container = DIContainerMock.previewMock() // can be used specific mock, but this one fits our needs for now
        let converterVM = CurrencyConverterVM(diContainer: container)

        let rate = Rate(currency: "USD", description: "Dollar", sellRate: "1.4", buyRate: "1.6", sellTransfer: "1.45", buyTransfer: "1.55")
        let currency = Currency(id: "EUR", description: "Euro", reverseUsdQuot: false, rates: [rate])

        converterVM.selectedCurrency = currency

        let result = try awaitPublisher(converterVM.$selectedRate.dropFirst())
        XCTAssertEqual(result.id, rate.id)
    }

    func testInputFieldCleansing() throws {
        let container = DIContainerMock.previewMock()
        let converterVM = CurrencyConverterVM(diContainer: container)

        converterVM.isSellingFieldEditing.send(true)
        converterVM.isBuyingFieldEditing.send(false)

        converterVM.sellingCurrencyValue = "10"
        var result = try awaitPublisher(converterVM.$sellingCurrencyValue)
        XCTAssertEqual(result, "10")

        converterVM.sellingCurrencyValue = "10.01"
        result = try awaitPublisher(converterVM.$sellingCurrencyValue)
        XCTAssertEqual(result, "10.01")

        converterVM.sellingCurrencyValue = "aaa"
        result = try awaitPublisher(converterVM.$sellingCurrencyValue.dropFirst())
        XCTAssertEqual(result, "")

        converterVM.sellingCurrencyValue = "10.00.0"
        result = try awaitPublisher(converterVM.$sellingCurrencyValue.dropFirst())
        XCTAssertEqual(result, "10.000")

        converterVM.sellingCurrencyValue = ".10"
        result = try awaitPublisher(converterVM.$sellingCurrencyValue.dropFirst())
        XCTAssertEqual(result, "10")
    }
}
