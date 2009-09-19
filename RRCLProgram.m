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

- (RRCLKernel *)kernelWithName:(NSString *)kernelName
{
	return [[[RRCLKernel alloc] initWithKernelName:kernelName inProgram:program] autorelease];
}

@end
