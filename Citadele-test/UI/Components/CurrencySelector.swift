//
//  CurrencySelector.swift
//  Citadele-test
//
//  Created by Pavels Vetlugins on 16/11/2022.
//

import Foundation
import SwiftUI

struct CurrencySelector: View {
    @Binding var inputField: String
    let currencyTitle: String
    let currencyCode: String

    var body: some View {
        VStack {
            HStack {
                Text(currencyTitle)
                Spacer()
                Text(currencyCode)
            }

            HStack {
                Button(currencyCode, action: {
                    // show selecotr
                })
                TextField("", text: $inputField)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
        }
    }
}

struct CurrencySelector_Previews: PreviewProvider {
    static var previews: some View {
        CurrencySelector(inputField: .constant(""), currencyTitle: "Euro", currencyCode: "EUR")
    }
}
