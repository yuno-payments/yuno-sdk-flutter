//
//  RemoveSubViews.swift
//  Pods
//
//  Created by steven on 9/09/24.
//

import Foundation
import UIKit

extension UIView {
    func removeAllSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }
    func removeAllSubviews<T: UIView>(type: T.Type) {
        subviews
            .filter { $0.isMember(of: type) }
            .forEach { $0.removeFromSuperview() }
    }
}
