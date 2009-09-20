// RROpenCL RRCLBuffer.m
//
// Copyright © 2009, Roy Ratcliffe, Pioneering Software, United Kingdom
// All rights reserved
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

#import "RRCLBuffer.h"

@implementation RRCLBuffer

// designated initialiser
- (id)initWithContext:(cl_context)aContext flags:(cl_mem_flags)flags size:(size_t)size hostPtr:(void *)hostPtr
{
	self = [super init];
	if (self)
	{
		cl_int errcode;
		mem = clCreateBuffer(aContext, flags, size, hostPtr, &errcode);
		if (NULL == mem)
		{
			[self release];
			self = nil;
		}
	}
	return self;
}
- (id)initReadWriteWithContext:(cl_context)aContext size:(size_t)size
{
	return [self initWithContext:aContext flags:CL_MEM_READ_WRITE size:size hostPtr:NULL];
}
- (id)initWriteOnlyWithContext:(cl_context)aContext size:(size_t)size
{
	return [self initWithContext:aContext flags:CL_MEM_WRITE_ONLY size:size hostPtr:NULL];
}
- (id)initReadOnlyWithContext:(cl_context)aContext size:(size_t)size
{
	return [self initWithContext:aContext flags:CL_MEM_READ_ONLY size:size hostPtr:NULL];
}

- (cl_mem)mem
{
	return mem;
}

- (void)dealloc
{
	clReleaseMemObject(mem);
	[super dealloc];
}
- (void)finalize
{
	clReleaseMemObject(mem);
	[super finalize];
}

@end
