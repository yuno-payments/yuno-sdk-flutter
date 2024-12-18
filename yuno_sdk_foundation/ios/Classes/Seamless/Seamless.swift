//
//  Sample.swift
//  yuno_sdk_foundation
//
//  Created by steven on 14/12/24.
//

import Foundation
import YunoSDK
import Flutter

class Seamless {
    let methodChannel: FlutterMethodChannel
    init(methodChannel: FlutterMethodChannel) {
        self.methodChannel = methodChannel
    }
    private var keyWindow: UIWindow? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
    var rootViewController: UIViewController? {
        keyWindow?.rootViewController
    }
    @MainActor
    func startSeamless(call: FlutterMethodCall, result: @escaping FlutterResult) async {
                guard let viewController = self.rootViewController,
                let args = call.arguments as? [String: Any]  else {
                    result(YunoError.invalidArguments())
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let model = try decoder.decode(SeamlessModel.self, from: args)
                    if model.paymentMethodSelected.paymentMethodType.isEmpty ||
                        model.checkoutSession.isEmpty || model.countryCode.isEmpty {
                        result(YunoError
                            .customError(
                                code: "6",
                                message: "Missing params",
                                details: "param:\(model.paymentMethodSelected.paymentMethodType) is empty"
                            )
                        )
                    }
                let state = await Yuno.startPaymentSeamlessLite(
                        with: SeamlessParams(
                            checkoutSession: model.checkoutSession,
                            countryCode: model.countryCode,
                            language: model.language,
                            viewController: viewController
                        ),
                        paymentSelected: model.paymentMethodSelected,
                        showPaymentStatus: model.showPaymentStatus
                    )
                    result(state.rawValue)
                } catch {
                    result(YunoError.somethingWentWrong())
                }
            }
}
