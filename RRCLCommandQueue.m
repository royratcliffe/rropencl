// RROpenCL RRCLCommandQueue.m
//
// Copyright © 2009, Roy Ratcliffe, Lancaster, United Kingdom
// All rights reserved
//
//------------------------------------------------------------------------------

#import "RRCLCommandQueue.h"

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

- (void)flush
{
	clFlush(commandQueue);
}
- (void)finish
{
	clFinish(commandQueue);
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
