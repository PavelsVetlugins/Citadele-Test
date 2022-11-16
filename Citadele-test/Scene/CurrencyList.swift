//
//  CurrencyList.swift
//  Citadele-test
//
//  Created by Pavels Vetlugins on 16/11/2022.
//

import SwiftUI

struct CurrencyList<T: CurrencyPresentable>: View {
    @State var selected: T?
    let currencies: [T]
    var onSelect: (String) -> Void

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
                    onSelect(currency.id)
                }
            }
        }
    }
}
