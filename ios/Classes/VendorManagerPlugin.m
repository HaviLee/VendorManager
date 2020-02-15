#import "VendorManagerPlugin.h"
#if __has_include(<vendor_manager/vendor_manager-Swift.h>)
#import <vendor_manager/vendor_manager-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "vendor_manager-Swift.h"
#endif

@implementation VendorManagerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftVendorManagerPlugin registerWithRegistrar:registrar];
}
@end
