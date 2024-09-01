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
    var paymentMetdhodSelected: PaymentMethod
    init(
         countryCode: String,
         paymentMetdhodSelected: PaymentMethod,
         showPaymentStatus: Bool,
         checkoutSession: String
    ) {
        self.countryCode = countryCode
        self.paymentMetdhodSelected = paymentMetdhodSelected
        self.showPaymentStatus = showPaymentStatus
        self.checkoutSession = checkoutSession
    }
}
