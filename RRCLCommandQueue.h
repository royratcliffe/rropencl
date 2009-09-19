// RROpenCL RRCLCommandQueue.h
//
// Copyright © 2009, Roy Ratcliffe, Lancaster, United Kingdom
// All rights reserved
//
//------------------------------------------------------------------------------

#import <Foundation/Foundation.h>

#import <OpenCL/OpenCL.h>

@interface RRCLCommandQueue : NSObject
{
	cl_command_queue commandQueue;
}

- (id)initWithContext:(cl_context)aContext deviceID:(cl_device_id)aDeviceID;

- (void)flush;
- (void)finish;

@end
