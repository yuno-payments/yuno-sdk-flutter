import Flutter
import UIKit
import YunoSDK


public class YunoSdkFoundationPlugin: NSObject, FlutterPlugin {
    fileprivate let instance: YunoMethods = YunoMethods()

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "yuno/payments", binaryMessenger: registrar.messenger())
    let instanceSDK = YunoSdkFoundationPlugin()
    registrar.addMethodCallDelegate(instanceSDK, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
            result(FlutterError(code: "UNAVAILABLE", message: "UIWindow is not available", details: nil))
            return
        }
    switch call.method {
    case "initialize":
        instance.handleInitialize(call: call, result: result)

    default:
      result(FlutterMethodNotImplemented)
    }
  }
}


