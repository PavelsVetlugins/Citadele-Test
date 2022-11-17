//
//  CurrencyConverterVMTest.swift
//  Citadele-testTests
//
//  Created by Pavels Vetlugins on 17/11/2022.
//

@testable import Citadele_test
import XCTest

final class CurrencyConverterVMTest: XCTestCase {
    func testAAA() {
        let container = DIContainerMock.previewMock() // can be used specific mock, but this one fits our needs for now

        let converterVM = CurrencyConverterVM(diContainer: container)
//        converterVM.
    }
}
