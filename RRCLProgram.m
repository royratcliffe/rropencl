// RROpenCL RRCLProgram.m
//
// Copyright © 2009, Roy Ratcliffe, Lancaster, United Kingdom
// All rights reserved
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

- (RRCLKernel *)kernelWithName:(NSString *)kernelName
{
	return [[[RRCLKernel alloc] initWithKernelName:kernelName inProgram:program] autorelease];
}

@end
