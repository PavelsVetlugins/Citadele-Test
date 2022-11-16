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
    let onCurrecnyTap: () -> Void
    let onEditing: (Bool) -> Void

    var body: some View {
        VStack {
            HStack {
                Text(currencyTitle)
                Spacer()
                Text(currencyCode)
            }

            HStack {
                Button(currencyCode, action: {
                    onCurrecnyTap()
                })
                TextField("0", text: $inputField, onEditingChanged: onEditing)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
        }
    }
}

struct CurrencySelector_Previews: PreviewProvider {
    static var previews: some View {
        CurrencySelector(inputField: .constant(""), currencyTitle: "Euro", currencyCode: "EUR", onCurrecnyTap: {}, onEditing: { _ in })
    }
}
