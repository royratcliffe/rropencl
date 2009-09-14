// OpenCL RRCLDevice.h
//
// Copyright © 2009, Roy Ratcliffe, Lancaster, United Kingdom
// All rights reserved
//
//------------------------------------------------------------------------------

#import <Foundation/Foundation.h>

#import <OpenCL/OpenCL.h>

@interface RRCLDevice : NSObject
{
	cl_device_id deviceID;
}

- (id)initWithDeviceID:(cl_device_id)aDeviceID;
- (cl_device_id)deviceID;

- (NSString *)stringForDeviceInfo:(cl_device_info)deviceInfo;
- (NSString *)deviceName;
- (NSString *)deviceVendor;
- (NSString *)driverVersion;
- (NSString *)deviceProfile;
- (NSString *)deviceVersion;
- (NSString *)deviceExtensions;

+ (NSArray *)devicesForPlatform:(cl_platform_id)platformID type:(cl_device_type)deviceType;

@end
