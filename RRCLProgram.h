// RROpenCL RRCLProgram.h
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

@class RRCLKernel;

@interface RRCLProgram : NSObject
{
	cl_program program;
}

- (id)initWithSource:(NSString *)source inContext:(cl_context)aContext;

- (void)build;

- (cl_uint)referenceCount;
	// Returns the program reference count. However, take care because the
	// OpenCL 1.0.43 specification warns, "The reference count returned should
	// be considered immediately stale. It is unsuitable for general use in
	// applications. This feature is provided for identifying memory leaks." See
	// p. 95.
- (cl_context)context;
- (cl_uint)numberOfDevices;

//------------------------------------------------------------------- Build Info

- (cl_build_status)statusForDeviceID:(cl_device_id)deviceID;
- (NSString *)optionsForDeviceID:(cl_device_id)deviceID;
- (NSString *)logForDeviceID:(cl_device_id)deviceID;

- (RRCLKernel *)kernelWithName:(NSString *)kernelName;

@end
