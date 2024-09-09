//
//  StartPaymentModel.swift
//  yuno_sdk_foundation
//
//  Created by steven on 21/08/24.
//

import Foundation

class StartPayment: Codable {
    var countryCode: String
    var showPaymentStatus: Bool
    var checkoutSession: String
    var paymentMethodSelected: PaymentMethod
    init(
         countryCode: String,
         paymentMethodSelected: PaymentMethod,
         showPaymentStatus: Bool,
         checkoutSession: String
    ) {
        self.countryCode = countryCode
        self.paymentMethodSelected = paymentMethodSelected
        self.showPaymentStatus = showPaymentStatus
        self.checkoutSession = checkoutSession
    }
}
