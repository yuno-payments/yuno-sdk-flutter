import Flutter
import UIKit
import YunoSDK

public class YunoSdkFoundationPlugin: NSObject, FlutterPlugin {
    fileprivate var instance: YunoMethods?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "yuno/payments", binaryMessenger: registrar.messenger())
    let instanceSDK = YunoSdkFoundationPlugin()
    instanceSDK.instance = YunoMethods(methodChannel: channel)
    registrar.addMethodCallDelegate(instanceSDK, channel: channel)
  }
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let instance = self.instance else {
      return
    }
    switch call.method {
    case Keys.initialize.rawValue:
        instance.handleInitialize(call: call, result: result)
    case Keys.startPaymentLite.rawValue:
        instance.handleStartPaymentLite(call: call, result: result)
    case Keys.continuePayment.rawValue:
        instance.continuePayment(call: call, result: result)
    case Keys.hideLoader.rawValue:
        instance.handleHideLoader(call: call, result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
