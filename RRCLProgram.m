// RROpenCL RRCLProgram.m
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

#import "RRCLProgram.h"
#import "RRCLKernel.h"

@implementation RRCLProgram

- (id)initWithSource:(NSString *)source inContext:(cl_context)aContext
{
	self = [super init];
	if (self)
	{
		cl_int errcode;
		const char *string = [source cStringUsingEncoding:NSASCIIStringEncoding];
		program = clCreateProgramWithSource(aContext, 1, &string, NULL, &errcode);
		if (CL_SUCCESS != errcode)
		{
			[self release];
			self = nil;
		}
	}
	return self;
}

- (void)dealloc
{
	clReleaseProgram(program);
	[super dealloc];
}
- (void)finalize
{
	clReleaseProgram(program);
	[super finalize];
}

- (void)build
{
	clBuildProgram(program, 0, NULL, "", NULL, NULL);
}

- (cl_build_status)statusForDevice:(cl_device_id)deviceID
{
	// Returns the error code if not successful, e.g. returns CL_INVALID_DEVICE
	// if deviceID is not in the list of devices associated with the program.
	// Doing this makes an important assumption about build status codes and
	// error codes. It assumes the two domains do not overlap for the building
	// information context. This turns out to be true for OpenCL version 1.0 but
	// may not always remain true.
	cl_build_status status;
	cl_int errcode;
	if (CL_SUCCESS != (errcode = clGetProgramBuildInfo(program, deviceID, CL_PROGRAM_BUILD_STATUS, sizeof(status), &status, NULL)))
	{
		return errcode;
	}
	return status;
}
- (NSString *)stringForBuildInfo:(cl_program_build_info)buildInfo device:(cl_device_id)deviceID
{
	size_t size;
	if (CL_SUCCESS != clGetProgramBuildInfo(program, deviceID, buildInfo, 0, NULL, &size))
	{
		return nil;
	}
	char info[size];
	if (CL_SUCCESS != clGetProgramBuildInfo(program, deviceID, buildInfo, size, info, NULL))
	{
		return nil;
	}
	return [NSString stringWithCString:info encoding:NSASCIIStringEncoding];
}
- (NSString *)optionsForDevice:(cl_device_id)deviceID
{
	return [self stringForBuildInfo:CL_PROGRAM_BUILD_OPTIONS device:deviceID];
}
- (NSString *)logForDevice:(cl_device_id)deviceID
{
	return [self stringForBuildInfo:CL_PROGRAM_BUILD_LOG device:deviceID];
}

- (RRCLKernel *)kernelWithName:(NSString *)kernelName
{
	return [[[RRCLKernel alloc] initWithKernelName:kernelName inProgram:program] autorelease];
}

@end
