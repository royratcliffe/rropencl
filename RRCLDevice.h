// OpenCL RRCLDevice.h
//
// Copyright © 2009, Roy Ratcliffe, Lancaster, United Kingdom
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS," WITHOUT WARRANTY OF ANY KIND, EITHER
// EXPRESSED OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO
// EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES
// OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
// ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
// DEALINGS IN THE SOFTWARE.
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
	// Argument deviceType specifies a bit mask describing which types of
	// computing device you require, including: the host processor, the GPU, a
	// dedicated CL accelerator, the default CL device or all of them.
	//
	//	CL_DEVICE_TYPE_DEFAULT
	//	CL_DEVICE_TYPE_CPU
	//	CL_DEVICE_TYPE_GPU
	//	CL_DEVICE_TYPE_ACCELERATOR
	//	CL_DEVICE_TYPE_ALL
	//

@end
