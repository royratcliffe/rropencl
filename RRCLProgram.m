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

// Maintain a strong-to-strong map table for translating cl_program opaques to
// their corresponding RRCLProgram wrapper instance. Class method
// -wrapperForProgram:program applies the translation; takes a cl_program,
// answers an RRCLProgram instance by creating a wrapper if necessary.

static NSMapTable *programs;
static void SetWrapperForProgram(RRCLProgram *wrapper, cl_program program)
{
	if (programs == nil)
	{
		programs = [[NSMapTable alloc] initWithKeyOptions:NSMapTableStrongMemory valueOptions:NSMapTableStrongMemory capacity:0];
	}
	[programs setObject:wrapper forKey:(id)program];
}
static void RemoveWrapperForProgram(cl_program program)
{
	[programs removeObjectForKey:(id)program];
	if ([programs count] == 0)
	{
		[programs release];
		programs = nil;
	}
}

- (id)initWithProgram:(cl_program)otherProgram
{
	self = [super init];
	if (self)
	{
		clRetainProgram(program = otherProgram);
		SetWrapperForProgram(self, program);
	}
	return self;
}

+ (RRCLProgram *)wrapperForProgram:(cl_program)program
{
	RRCLProgram *wrapper;
	if (programs == nil || (wrapper = [programs objectForKey:(id)program]) == nil)
	{
		wrapper = [[[self class] alloc] initWithProgram:program];
	}
	return wrapper;
}

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
		SetWrapperForProgram(self, program);
	}
	return self;
}

- (void)dealloc
{
	RemoveWrapperForProgram(program);
	clReleaseProgram(program);
	[super dealloc];
}
- (void)finalize
{
	RemoveWrapperForProgram(program);
	clReleaseProgram(program);
	[super finalize];
}

- (cl_int)build
{
	return clBuildProgram(program, 0, NULL, "", NULL, NULL);
}

//------------------------------------------------------------------------------
#pragma mark                                                                Info
//------------------------------------------------------------------------------

- (cl_uint)referenceCount
{
	cl_uint referenceCount;
	if (CL_SUCCESS != clGetProgramInfo(program, CL_PROGRAM_REFERENCE_COUNT, sizeof(referenceCount), &referenceCount, NULL))
	{
		return 0;
	}
	return referenceCount;
}
- (cl_context)context
{
	cl_context context;
	if (CL_SUCCESS != clGetProgramInfo(program, CL_PROGRAM_CONTEXT, sizeof(context), &context, NULL))
	{
		return NULL;
	}
	return context;
}
- (cl_uint)numberOfDevices
{
	cl_uint numberOfDevices;
	if (CL_SUCCESS != clGetProgramInfo(program, CL_PROGRAM_NUM_DEVICES, sizeof(numberOfDevices), &numberOfDevices, NULL))
	{
		return 0;
	}
	return numberOfDevices;
}

//------------------------------------------------------------------------------
#pragma mark                                                          Build Info
//------------------------------------------------------------------------------

- (cl_build_status)statusForDeviceID:(cl_device_id)deviceID
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
- (NSString *)stringForBuildInfo:(cl_program_build_info)buildInfo deviceID:(cl_device_id)deviceID
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
- (NSString *)optionsForDeviceID:(cl_device_id)deviceID
{
	return [self stringForBuildInfo:CL_PROGRAM_BUILD_OPTIONS deviceID:deviceID];
}
- (NSString *)logForDeviceID:(cl_device_id)deviceID
{
	return [self stringForBuildInfo:CL_PROGRAM_BUILD_LOG deviceID:deviceID];
}

- (RRCLKernel *)kernelWithName:(NSString *)kernelName
{
	return [[[RRCLKernel alloc] initWithKernelName:kernelName inProgram:program] autorelease];
}

@end
