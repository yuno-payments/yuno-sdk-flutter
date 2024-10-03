//
//  PaymentMetthodFactory.swift
//  Pods
//
//  Created by steven on 1/10/24.
//

import Foundation
import UIKit
import YunoSDK
import Flutter

public class PaymentMetthodFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger
    init(messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }
    public func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return PaymentMethodView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger
        )
    }
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}

class PaymentMethodView: NSObject, FlutterPlatformView, YunoMethodsViewDelegate {

    private let channel: FlutterMethodChannel
    private lazy var generator: MethodsView? = nil
    var localView: UIView = UIView()
    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger
    ) {
        channel = FlutterMethodChannel(
            name: "yuno/payment_methods_view/\(viewId)", binaryMessenger: messenger)
        super.init()
        generator = Yuno.methodsView(delegate: self)
        generatorView(args: args)
    }
    func generatorView(args: Any?) {
        guard let arg = args as? [String: Any] else {
             return
        }
        do {
            let decoder = JSONDecoder()
            let arguments = try decoder.decode(ViewArguments.self, from: arg)
            self.generator?.getPaymentMethodsView(checkoutSession: arguments.checkoutSession,
                                                  viewType: .separated) { [weak self] (view: UIView) in
                view.translatesAutoresizingMaskIntoConstraints = false
                guard let self = self else {
                    return
                }
                NSLayoutConstraint.activate([
                    view.widthAnchor.constraint(equalToConstant: arguments.width)
                ])
                self.localView.addSubview(view)
            }
        } catch {
            handleError(error)
        }
    }
    func handleError(_ error: Error) {
        let errorLabel = UILabel()
        errorLabel.text = "Failed to load the view."
        errorLabel.textColor = .red
        errorLabel.textAlignment = .center
        errorLabel.frame = localView.bounds
        localView.addSubview(errorLabel)
    }
    func yunoDidSelect(paymentMethod: any YunoSDK.PaymentMethodSelected) {
        channel.invokeMethod("onSelected", arguments: !paymentMethod.paymentMethodType.isEmpty)
    }

    func yunoDidSelect(enrollmentMethod: any YunoSDK.EnrollmentMethodSelected) {
    }
    func yunoUpdatePaymentMethodsViewHeight(_ height: CGFloat) {
        channel.invokeMethod("onHeightChange", arguments: height)
    }
    func yunoUpdateEnrollmentMethodsViewHeight(_ height: CGFloat) {
    }

    func view() -> UIView {
        return localView
    }
}
