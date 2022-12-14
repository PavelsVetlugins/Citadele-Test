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
    let actionTitle: String
    let currencyTitle: String
    let currencyCode: String
    let onCurrecnyTap: () -> Void
    let onEditing: (Bool) -> Void

    var body: some View {
        VStack {
            HStack {
                Text(currencyTitle)
                Spacer()
                Text(actionTitle)
            }

            HStack {
                Button(currencyCode, action: {
                    onCurrecnyTap()
                })
                TextField("Specify amount", text: $inputField, onEditingChanged: onEditing)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
        }
    }
}

struct CurrencySelector_Previews: PreviewProvider {
    static var previews: some View {
        CurrencySelector(inputField: .constant(""), actionTitle: "Buy", currencyTitle: "Euro", currencyCode: "EUR", onCurrecnyTap: {}, onEditing: { _ in })
    }
}
