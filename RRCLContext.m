// RROpenCL RRCLContext.m
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

#import "RRCLContext.h"
#import "RRCLDevice.h"
#import "RRCLCommandQueue.h"
#import "RRCLProgram.h"

void RRCLContextNotify(const char *errinfo, const void *private_info, size_t cb, void *user_data);

@implementation RRCLContext

- (id)initWithDeviceIDs:(NSArray *)deviceIDs
{
	self = [super init];
	if (self)
	{
		NSUInteger count = [deviceIDs count];
		cl_device_id ids[count];
		for (NSUInteger index = 0; index < count; index++)
		{
			ids[index] = [[deviceIDs objectAtIndex:index] deviceID];
		}
		cl_int errcode;
		context = clCreateContext(NULL, count, ids, RRCLContextNotify, self, &errcode);
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
	clReleaseContext(context);
	[super dealloc];
}
- (void)finalize
{
	clReleaseContext(context);
	[super finalize];
}

- (RRCLCommandQueue *)commandQueueForDeviceID:(cl_device_id)aDeviceID
{
	return [[[RRCLCommandQueue alloc] initWithContext:context deviceID:aDeviceID] autorelease];
}

- (RRCLProgram *)programWithSource:(NSString *)source
{
	return [[[RRCLProgram alloc] initWithSource:source inContext:context] autorelease];
}

- (void)notifyWithErrorInfo:(NSString *)errInfo data:(NSData *)data
{
	NSLog(@"%@ %@ %@", self, errInfo, data);
}

@end

void RRCLContextNotify(const char *errinfo, const void *private_info, size_t cb, void *user_data)
{
	[(RRCLContext *)user_data notifyWithErrorInfo:[NSString stringWithCString:errinfo encoding:NSASCIIStringEncoding] data:[NSData dataWithBytes:private_info length:cb]];
}
