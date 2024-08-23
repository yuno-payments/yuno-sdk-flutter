import Flutter
import UIKit
import YunoSDK

public class YunoSdkFoundationPlugin: NSObject, FlutterPlugin {
    fileprivate let instance: YunoMethods = YunoMethods()

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: "yuno/payments",
      binaryMessenger: registrar.messenger())
    let instanceSDK = YunoSdkFoundationPlugin()
    registrar.addMethodCallDelegate(instanceSDK, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      
    switch call.method {
        case Keys.initialize.rawValue:
        instance.handleInitialize(call: call, result: result)
        case Keys.startPaymentLite.rawValue:
        instance.handleStartPaymentLite(call: call, result: result)

    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
