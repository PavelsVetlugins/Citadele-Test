//
//  ParsingTest.swift
//  Citadele-testTests
//
//  Created by Pavels Vetlugins on 17/11/2022.
//

@testable import Citadele_test
import XCTest

final class ParsingTest: XCTestCase {
    func testCurrateResponseJsonParse() throws {
        let url = URL(fileURLWithPath: Bundle.main.path(forResource: "CurRateResponse", ofType: "json")!)
        let data = try! Data(contentsOf: url)
        let response = try JSONDecoder().decode(CurrateResponse.self, from: data)

        XCTAssertEqual(response.data.count, 12)
        XCTAssertEqual(response.data[0].id, "AUD")
        XCTAssertEqual(response.data[0].rates.count, 2)
    }
}
