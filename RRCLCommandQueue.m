// RROpenCL RRCLCommandQueue.m
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

#import "RRCLCommandQueue.h"
#import "RRCLBuffer.h"
#import "RRCLKernel.h"

@implementation RRCLCommandQueue

- (id)initWithContext:(cl_context)aContext deviceID:(cl_device_id)aDeviceID
{
	self = [super init];
	if (self)
	{
		cl_int errcode;
		commandQueue = clCreateCommandQueue(aContext, aDeviceID, 0, &errcode);
		if (CL_SUCCESS != errcode)
		{
			[self release];
			self = nil;
		}
	}
	return self;
}

//------------------------------------------------------------------------------
#pragma mark                                                                Info
//------------------------------------------------------------------------------

- (cl_context)context
{
	cl_context context;
	if (CL_SUCCESS != clGetCommandQueueInfo(commandQueue, CL_QUEUE_CONTEXT, sizeof(context), &context, NULL))
	{
		return NULL;
	}
	return context;
}
- (cl_device_id)deviceID
{
	cl_device_id deviceID;
	if (CL_SUCCESS != clGetCommandQueueInfo(commandQueue, CL_QUEUE_DEVICE, sizeof(deviceID), &deviceID, NULL))
	{
		return NULL;
	}
	return deviceID;
}
- (cl_uint)referenceCount
{
	cl_uint referenceCount;
	if (CL_SUCCESS != clGetCommandQueueInfo(commandQueue, CL_QUEUE_REFERENCE_COUNT, sizeof(referenceCount), &referenceCount, NULL))
	{
		return 0;
	}
	return referenceCount;
}

- (cl_int)flush
{
	return clFlush(commandQueue);
}
- (cl_int)finish
{
	return clFinish(commandQueue);
}

- (NSData *)enqueueReadBuffer:(RRCLBuffer *)aBuffer blocking:(cl_bool)blocking offset:(size_t)offset length:(size_t)cb
{
	NSMutableData *data = [NSMutableData dataWithLength:cb];
	if (CL_SUCCESS != clEnqueueReadBuffer(commandQueue, [aBuffer mem], blocking, offset, cb, [data mutableBytes], 0, NULL, NULL))
	{
		return nil;
	}
	return data;
}
- (cl_int)enqueueWriteBuffer:(RRCLBuffer *)aBuffer blocking:(cl_bool)blocking offset:(size_t)offset data:(NSData *)data
{
	return clEnqueueWriteBuffer(commandQueue, [aBuffer mem], blocking, offset, [data length], [data bytes], 0, NULL, NULL);
}
- (cl_int)enqueueNDRangeKernel:(RRCLKernel *)aKernel globalWorkSize:(size_t)globalWorkSize
{
	return clEnqueueNDRangeKernel(commandQueue, [aKernel kernel], 1, NULL, &globalWorkSize, NULL, 0, NULL, NULL);
}
- (cl_int)enqueueNDRangeKernel:(RRCLKernel *)aKernel globalWorkSize:(size_t)globalWorkSize localWorkSize:(size_t)localWorkSize
{
	return clEnqueueNDRangeKernel(commandQueue, [aKernel kernel], 1, NULL, &globalWorkSize, &localWorkSize, 0, NULL, NULL);
}

- (void)dealloc
{
	clReleaseCommandQueue(commandQueue);
	[super dealloc];
}
- (void)finalize
{
	clReleaseCommandQueue(commandQueue);
	[super finalize];
}

@end
