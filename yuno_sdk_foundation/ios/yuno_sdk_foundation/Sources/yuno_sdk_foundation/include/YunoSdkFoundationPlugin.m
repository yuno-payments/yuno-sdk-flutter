#import "YunoSdkFoundationPlugin.h"
#if __has_include(<yuno_sdk_foundation/yuno_sdk_foundation-Swift.h>)
#import <yuno_sdk_foundation/yuno_sdk_foundation-Swift.h>
#else
    // Support project import fallback if the generated compatibility header
    // is not copied when this plugin is created as a library.
    // https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "yuno_sdk_foundation-Swift.h"
#endif

SWIFT_CLASS("YunoSdkFoundationPlugin")
@interface YunoSdkFoundationPlugin : NSObject
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar;
@end
