//
//  CurrencyList.swift
//  Citadele-test
//
//  Created by Pavels Vetlugins on 16/11/2022.
//

import SwiftUI

struct CurrencyList: View {
    @State var selected: Currency?
    let currencies: [Currency]
    var onSelect: (Currency) -> Void

    var body: some View {
        List {
            ForEach(currencies) { currency in
                let isSelected = selected?.id == currency.id
                HStack {
                    Text(currency.id)
                        .foregroundColor(isSelected ? .red : Color.primary)
                    Text(currency.description)
                        .foregroundColor(isSelected ? .red : Color.primary)
                }.onTapGesture {
                    self.selected = currency
                    onSelect(currency)
                }
            }
        }
    }
}

struct CurrencyList_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyList(selected: Currency.mock(), currencies: [
            Currency.mock(),
            Currency.mock(),
            Currency.mock(),
            Currency.mock(),
            Currency.mock(),
            Currency.mock(),
        ], onSelect: { _ in })
    }
}
