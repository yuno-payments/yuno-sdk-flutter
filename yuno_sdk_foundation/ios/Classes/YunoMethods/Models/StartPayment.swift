//
//  StartPaymentModel.swift
//  yuno_sdk_foundation
//
//  Created by steven on 21/08/24.
//

import Foundation

class StartPayment: Codable {
    var showPaymentStatus: Bool
    var checkoutSession: String
    var paymentMetdhodSelected: PaymentMethod
    init(paymentMetdhodSelected: PaymentMethod,
         showPaymentStatus: Bool,
         checkoutSession: String
    ) {
        self.paymentMetdhodSelected = paymentMetdhodSelected
        self.showPaymentStatus = showPaymentStatus
        self.checkoutSession = checkoutSession
    }
}
