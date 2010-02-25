// RROpenCL RRCLKernel.m
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

#import "RRCLKernel.h"
#import "RRCLBuffer.h"
#import "RRCLProgram.h"

@implementation RRCLKernel

- (id)initWithKernelName:(NSString *)kernelName inProgram:(cl_program)aProgram
{
	self = [super init];
	if (self)
	{
		cl_int errcode;
		kernel = clCreateKernel(aProgram, [kernelName cStringUsingEncoding:NSASCIIStringEncoding], &errcode);
		if (CL_SUCCESS != errcode)
		{
			[self release];
			self = nil;
		}
	}
	return self;
}

- (cl_kernel)kernel
{
	return kernel;
}

- (void)dealloc
{
	clReleaseKernel(kernel);
	[super dealloc];
}
- (void)finalize
{
	clReleaseKernel(kernel);
	[super finalize];
}

- (cl_int)setArg:(cl_uint)argIndex toBuffer:(RRCLBuffer *)aBuffer
{
	cl_mem mem = [aBuffer mem];
	return clSetKernelArg(kernel, argIndex, sizeof(mem), &mem);
}

//------------------------------------------------------------------------------
#pragma mark                                                                Info
//------------------------------------------------------------------------------

- (NSString *)name
{
	size_t size;
	if (CL_SUCCESS != clGetKernelInfo(kernel, CL_KERNEL_FUNCTION_NAME, 0, NULL, &size))
	{
		return nil;
	}
	char info[size];
	if (CL_SUCCESS != clGetKernelInfo(kernel, CL_KERNEL_FUNCTION_NAME, size, info, NULL))
	{
		return nil;
	}
	return [NSString stringWithCString:info encoding:NSASCIIStringEncoding];
}
- (cl_uint)numberOfArgs
{
	cl_uint numberOfArgs;
	if (CL_SUCCESS != clGetKernelInfo(kernel, CL_KERNEL_NUM_ARGS, sizeof(numberOfArgs), &numberOfArgs, NULL))
	{
		return 0;
	}
	return numberOfArgs;
}
- (cl_uint)referenceCount
{
	cl_uint referenceCount;
	if (CL_SUCCESS != clGetKernelInfo(kernel, CL_KERNEL_REFERENCE_COUNT, sizeof(referenceCount), &referenceCount, NULL))
	{
		return 0;
	}
	return referenceCount;
}
- (cl_context)context
{
	cl_context context;
	if (CL_SUCCESS != clGetKernelInfo(kernel, CL_KERNEL_CONTEXT, sizeof(context), &context, NULL))
	{
		return NULL;
	}
	return context;
}
- (RRCLProgram *)program
{
	cl_program program;
	if (CL_SUCCESS != clGetKernelInfo(kernel, CL_KERNEL_PROGRAM, sizeof(program), &program, NULL))
	{
		return NULL;
	}
	return [RRCLProgram wrapperForProgram:program];
}

//------------------------------------------------------------------------------
#pragma mark                                                     Work Group Info
//------------------------------------------------------------------------------

- (size_t)workGroupSizeForDeviceID:(cl_device_id)deviceID
{
	size_t size;
	if (CL_SUCCESS != clGetKernelWorkGroupInfo(kernel, deviceID, CL_KERNEL_WORK_GROUP_SIZE, sizeof(size), &size, NULL))
	{
		return 0;
	}
	return size;
}

@end
