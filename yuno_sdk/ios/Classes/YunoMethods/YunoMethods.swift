    //
    //  YunoMethods.swift
    //  Pods
    //
    //  Created by steven on 10/08/24.
    //

import Flutter
import Foundation
import UIKit
import YunoSDK

class YunoMethods: YunoPaymentFullDelegate {
    var customerSession: String = ""
    var countryCode: String = ""
    var checkoutSession: String = ""
    var language: String?
    let methodChannel: FlutterMethodChannel
    private var paymentMethodsViewChannel: FlutterMethodChannel?
    private lazy var window: UIWindow? = {
        return UIApplication.shared.windows.first { $0.isKeyWindow }
    }()
    var viewController: UIViewController? {
        window?.rootViewController
    }

    init(methodChannel: FlutterMethodChannel) {
        self.methodChannel = methodChannel
    }

    func setPaymentMethodsViewChannel(_ channel: FlutterMethodChannel) {
        paymentMethodsViewChannel = channel
    }

    func yunoCreatePayment(with token: String) {
        NSLog("YUNO iOS OTT ")
        handleOTT(token: token)
    }
    
    func yunoPaymentResult(_ result: YunoSDK.Yuno.Result) {
        NSLog("YUNO iOS Result -> selected=%@", "\(result.rawValue)")
        
        handleStatus(status: result.rawValue)
    }
    private func initialize(app: AppConfiguration) {
        let appearance = app.configuration?.appearance
        let yunoConfig = app.yunoConfig
        self.countryCode = app.countryCode
        // Note: checkoutSession will be set when YunoPaymentMethods is created or when startPaymentLite is called
        Yuno.initialize(
            apiKey: app.apiKey,
            config: YunoConfig(
                appearance: Yuno.Appearance(
                    fontFamily: appearance?.fontFamily,
                    accentColor: appearance?.accentColor,
                    buttonBackgroundColor: appearance?.buttonBackgroundColor,
                    buttonTitleColor: appearance?.buttonTitleBackgroundColor,
                    buttonBorderColor: appearance?.buttonBorderBackgroundColor,
                    secondaryButtonBackgroundColor: appearance?.secondaryButtonBackgroundColor,
                    secondaryButtonTitleColor: appearance?.secondaryButtonTitleBackgroundColor,
                    secondaryButtonBorderColor: appearance?.secondaryButtonBorderBackgroundColor,
                    disableButtonBackgroundColor: appearance?.disableButtonBackgroundColor,
                    disableButtonTitleColor: appearance?.disableButtonTitleBackgroundColor,
                    checkboxColor: appearance?.checkboxColor),
                saveCardEnabled: yunoConfig.saveCardEnable ?? false,
                keepLoader: yunoConfig.keepLoader ?? false
            )
        )
    }
    
    func yunoDidSelect(paymentMethod: any YunoSDK.PaymentMethodSelected) {
        let selected = !paymentMethod.paymentMethodType.isEmpty
        let paymentMethodData: [String: Any?] = [
            "vaultedToken": paymentMethod.vaultedToken,
            "paymentMethodType": paymentMethod.paymentMethodType
        ]
        if let paymentMethodsViewChannel = paymentMethodsViewChannel {
            paymentMethodsViewChannel.invokeMethod("onSelected", arguments: paymentMethodData)
            return
        }
        methodChannel.invokeMethod("onSelected", arguments: paymentMethodData)
    }
    
    func yunoUpdatePaymentMethodsViewHeight(_ height: CGFloat) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let heightValue = Double(height)
            if let paymentMethodsViewChannel = self.paymentMethodsViewChannel {
                paymentMethodsViewChannel.invokeMethod("onHeightChange", arguments: heightValue)
                return
            }
            self.methodChannel.invokeMethod("onHeightChange", arguments: heightValue)
        }
    }
    func yunoDidUnenrollSuccessfully(_ success: Bool) {
        
    }
}

extension YunoMethods {
    func startCheckoutUpdate(cc: String, cs: String) {
        countryCode = cc
        checkoutSession = cs
    }

    func handleStatus(status: Int) {
        methodChannel.invokeMethod(Keys.status.rawValue, arguments: status)
    }
    func handleReceiveDeeplink(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? String,
              !args.isEmpty,
              let safeURL = URL(string: args) else {
            result(YunoError.invalidArguments())
            return
        }
        Yuno.receiveDeeplink(safeURL)
    }
    func handleOTT(token: String) {
        methodChannel.invokeMethod(Keys.ott.rawValue, arguments: token)
    }
    func handleHideLoader(call: FlutterMethodCall, result: @escaping FlutterResult) {
        Yuno.hideLoader()
    }
    func continuePayment(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? Bool else {
            result(YunoError.invalidArguments())
            return
        }
        Yuno.continuePayment()
    }
    func handleStartPayment(call: FlutterMethodCall, result: @escaping FlutterResult) {
         NSLog("YUNO iOS -> handleStartPayment called")
        guard let args = call.arguments as? [String: Any] else {
            result(YunoError.invalidArguments())
            return
        }
        do {
            let decoder = JSONDecoder()
            let startPayment = try decoder.decode(StartPayment.self, from: args)
            
            // Verify that checkoutSession and countryCode are set
            // These should be set during initialize or from a previous startPaymentLite call
            // or when YunoPaymentMethods widget is created
            guard !self.checkoutSession.isEmpty, !self.countryCode.isEmpty else {
                 NSLog("YUNO iOS -> Missing checkoutSession or countryCode")
                result(YunoError.customError(
                    code: "7",
                    message: "Missing configuration",
                    details: "checkoutSession and countryCode must be set before calling startPayment. Ensure you have created YunoPaymentMethods widget with a checkoutSession, or call startPaymentLite first to set these values."
                ))
                return
            }
            
            // Execute on main thread like startPaymentLite does
            // The SDK needs checkoutSession and countryCode to be set before calling startPayment
            // These should already be set when YunoPaymentMethods widget is created
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    result(YunoError.somethingWentWrong())
                    return
                }
                // Ensure the SDK has the latest checkoutSession and countryCode
                // This is critical - the SDK needs these values to fetch payment methods
                 NSLog("YUNO iOS -> Starting Payment FULL with checkoutSession: %@, countryCode: %@", self.checkoutSession, self.countryCode)
                
                // The SDK native layer needs these values to be set before startPayment
                // They should be set when YunoPaymentMethods widget calls getPaymentMethodViewAsync
                // If they're not set, the SDK will fail when trying to get payment methods
                Yuno.startPayment(
                    showPaymentStatus: startPayment.showPaymentStatus
                )
                result(true)
            }
        } catch {
           // NSLog("YUNO iOS <- fallo full called")
            result(YunoError.somethingWentWrong())
        }
    }
    func handleStartPaymentLite(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any] else {
            result(YunoError.invalidArguments())
            return
        }
        do {
            let decoder = JSONDecoder()
            let startPayment = try decoder.decode(StartPaymentLite.self, from: args)
            if startPayment.paymentMethodSelected.paymentMethodType.isEmpty ||
                startPayment.checkoutSession.isEmpty || startPayment.countryCode.isEmpty {
                result(YunoError
                    .customError(
                        code: "6",
                        message: "Missing params",
                        details: "param:\(startPayment.paymentMethodSelected.paymentMethodType) is empty"
                    )
                )
                return
            }
            self.countryCode = startPayment.countryCode
            self.checkoutSession = startPayment.checkoutSession
            DispatchQueue.main.async { [weak self] in
                guard let self = self else {
                    return
                }
                 NSLog("YUNO iOS -> Starting Payment FULL with language: %@", self.language ?? "nil")
                Yuno.startPaymentLite(
                    with: self,
                    paymentSelected: startPayment.paymentMethodSelected,
                    showPaymentStatus: startPayment.showPaymentStatus
                )
                result(true)
             //   NSLog("YUNO iOS startPaymentLite returned")
            }
        } catch {
            result(YunoError.somethingWentWrong())
        }
    }
    func handleInitialize(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any] else {
            result(YunoError.invalidArguments())
            return
        }
        do {
            let decoder = JSONDecoder()
            let app = try decoder.decode(AppConfiguration.self, from: args)
            if app.apiKey.isEmpty {
                result(YunoError.missingParams())
            }
            self.language = app.yunoConfig.lang
            self.initialize(app: app )
            result(true)
        } catch {
            result(YunoError.somethingWentWrong())
        }
    }
}
