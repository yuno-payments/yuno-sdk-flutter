//
//  StartEnrollment.swift
//  Pods
//
//  Created by steven on 21/10/24.
//

class StartEnrollmentPayment: Codable {
    var countryCode: String
    var customerSession: String
    var showPaymentStatus: Bool
    init(
        countryCode: String,
        showPaymentStatus: Bool,
        customerSession: String
    ) {
        self.countryCode = countryCode
        self.showPaymentStatus = showPaymentStatus
        self.customerSession = customerSession
    }
}
