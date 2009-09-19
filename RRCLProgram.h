// RROpenCL RRCLProgram.h
//
// Copyright © 2009, Roy Ratcliffe, Lancaster, United Kingdom
// All rights reserved
//
//------------------------------------------------------------------------------

#import <Foundation/Foundation.h>

#import <OpenCL/OpenCL.h>

@class RRCLKernel;

@interface RRCLProgram : NSObject
{
	cl_program program;
}

- (id)initWithSource:(NSString *)source inContext:(cl_context)aContext;

- (void)build;
- (RRCLKernel *)kernelWithName:(NSString *)kernelName;

@end
