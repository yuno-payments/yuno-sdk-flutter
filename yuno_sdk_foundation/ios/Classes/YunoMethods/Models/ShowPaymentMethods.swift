//
//  ShowPaymentMethodsModel.swift
//  Pods
//
//  Created by steven on 5/09/24.
//

import Foundation
final class ShowPaymentMethods: Codable, Sendable {
   let checkoutSession: String
    init(checkoutSession: String) {
        self.checkoutSession = checkoutSession
    }
}
