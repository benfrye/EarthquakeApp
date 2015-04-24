//
//  UIDevice+WTADeviceHelpers.h
//  WTADeviceHelpers
//
//  Created by Joel Garrett on 8/4/14.
//  Copyright (c) 2014 WillowTree Apps, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const WTANetworkInterfaceWiFi;
extern NSString * const WTANetworkInterfaceCellular;
extern NSString * const WTANetworkAddressTypeIPv4;
extern NSString * const WTANetworkAddressTypeIPv6;

@interface UIDevice (WTADeviceHelpers)

/**
 *  Provides a summary of the current device
 *
 *  @return the device summary
 */
- (NSDictionary *)wta_deviceSummary;

/**
 *  Provides and HTML version of the device
 *  summary dictionary for use in support
 *  emails.
 *
 *  @return the HTML device summary
 */
- (NSString *)wta_HTMLDeviceSummary;

/**
 *  Provides a user agent string for use
 *  in HTTP requests.
 *
 *  @return the user agent string
 */
- (NSString *)wta_userAgent;

/**
 *  Provides the SSID, BSSID and SSIDData
 *  for all supported network interfaces.
 *
 *  @return the network info
 */
+ (NSDictionary *)wta_currentNetworkInfo;

/**
 *  Provides a dictionary of all IP address
 *  discovered for both WiFi and cellular
 *  hardware interfaces.
 *
 *  @return ip address for all hardware interfaces
 */
+ (NSDictionary *)wta_currentIPAddresses;

/**
 *  Returns support status for a rear
 *  facing camera.
 *
 *  @return camera support status
 */
+ (BOOL)wta_supportsRearFacingCamera;

/**
 *  Returns support status for auto-focus
 *  camera.
 *
 *  @return camera support status
 */
+ (BOOL)wta_supportsAutoFocus;

@end

@interface NSBundle (WTADeviceHelpers)

/**
 *  Provides the bundle identifier
 *
 *  @return the bundle identifier
 */
- (NSString *)wta_bundleIdentifier;

/**
 *  Provides the bundle version
 *
 *  @return the bundle version
 */
- (NSString *)wta_bundleVersion;

/**
 *  Provides a summary of the bundle
 *
 *  @return the bundle summary
 */
- (NSDictionary *)wta_bundleSummary;

@end
