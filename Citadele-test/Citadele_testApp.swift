//
//  Citadele_testApp.swift
//  Citadele-test
//
//  Created by Pavels Vetlugins on 16/11/2022.
//

import SwiftUI

@main
struct Citadele_testApp: App {
    @ObservedObject var alertManager = AlertManager()

    init() {
        appLaunch()
    }

    var body: some Scene {
        WindowGroup {
            HomeScene()
                .alert(isPresented: $alertManager.isPresented) {
                    alertManager.alert
                }
        }
    }

    private func appLaunch() {
        DIContainer.shared.register(type: AlertManager.self, component: alertManager)
        DIContainer.shared.register(type: CurrencyRateServiceProviding.self, component: CurrencyRateService())
    }
}
