//
//  AlertManager.swift
//  Citadele-test
//
//  Created by Pavels Vetlugins on 17/11/2022.
//

import Foundation

import Combine
import SwiftUI

class AlertManager: ObservableObject {
    @Published var isPresented: Bool = false

    var alert: Alert = .init(title: Text(""))

    func presentAlert(infoAlert: InfoAlert) {
        alert = infoAlert.alert()
        isPresented = true
    }
}

protocol InfoAlert {
    var titleText: Text { get }
    var messageText: Text { get }
    var primaryButton: Alert.Button { get }
    var secondaryButton: Alert.Button? { get }

    func alert() -> Alert
}

extension InfoAlert {
    func alert() -> Alert {
        if let secondaryButton = secondaryButton {
            return Alert(title: titleText, message: messageText, primaryButton: primaryButton, secondaryButton: secondaryButton)
        } else {
            return Alert(title: titleText, message: messageText, dismissButton: primaryButton)
        }
    }
}

struct NetworkError: InfoAlert {
    var titleText = Text("Networ Error")
    var messageText = Text("Please try again later")
    var primaryButton: Alert.Button
    var secondaryButton: Alert.Button?

    init(onRetry: @escaping () -> Void) {
        primaryButton = Alert.Button.default(Text("Retry"), action: onRetry)
    }
}
