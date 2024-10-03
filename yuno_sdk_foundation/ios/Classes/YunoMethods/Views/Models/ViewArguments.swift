//
//  ViewArguments.swift
//  Pods
//
//  Created by steven on 1/10/24.
//

import Foundation

class ViewArguments: Codable {
    var checkoutSession: String
    var width: CGFloat
    init(
        checkoutSession: String,
        width: CGFloat
    ) {
        self.checkoutSession = checkoutSession
        self.width = width
    }
}
