//
//  SeamlessModel.swift
//  Pods
//
//  Created by steven on 12/12/24.
//

import Foundation

class SeamlessModel: Codable {
    var countryCode: String
    var language: String?
    var checkoutSession: String
    var showPaymentStatus: Bool
    var paymentMethodSelected: PaymentMethod
    init(
        countryCode: String,
        paymentMethodSelected: PaymentMethod,
        showPaymentStatus: Bool,
        checkoutSession: String,
        language: String?
    ) {
        self.language = language
        self.countryCode = countryCode
        self.paymentMethodSelected = paymentMethodSelected
        self.showPaymentStatus = showPaymentStatus
        self.checkoutSession = checkoutSession
    }
}
