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
    private var yunoMethod: YunoMethods
    init(messenger: FlutterBinaryMessenger, yunoMethod: YunoMethods) {
        self.messenger = messenger
        self.yunoMethod = yunoMethod
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
            binaryMessenger: messenger,
            yunoMethod: yunoMethod
        )
    }
    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}

class PaymentMethodView: NSObject, FlutterPlatformView {

    private var yunoMethod: YunoMethods
    private let channel: FlutterMethodChannel
    var localView: UIView = UIView()
    init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger,
        yunoMethod: YunoMethods
    ) {
        self.yunoMethod = yunoMethod
        channel = FlutterMethodChannel(
            name: "yuno/payment_methods_view/\(viewId)", binaryMessenger: messenger)
        super.init()
        generatorView(args: args)
    }
    func generatorView(args: Any?) {
        guard let arg = args as? [String: Any] else {
             return
        }
        do {
            let decoder = JSONDecoder()
            let arguments = try decoder.decode(ViewArguments.self, from: arg)
            self.yunoMethod.startCheckoutUpdate(cc: arguments.countryCode, cs: arguments.checkoutSession)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                let methodsList: UIView = Yuno.getPaymentMethodView(delegate: self.yunoMethod)
                methodsList.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    methodsList.widthAnchor.constraint(equalToConstant: arguments.width),
                    
                ])
                self.localView.addSubview(methodsList)
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


    func view() -> UIView {
        return localView
    }
}
