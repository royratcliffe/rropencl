// RROpenCL RRCLKernel.m
//
// Copyright © 2009, Roy Ratcliffe, Lancaster, United Kingdom
// All rights reserved
//
//------------------------------------------------------------------------------

#import "RRCLKernel.h"

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

@end
