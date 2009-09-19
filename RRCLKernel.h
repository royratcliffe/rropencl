// RROpenCL RRCLKernel.h
//
// Copyright © 2009, Roy Ratcliffe, Lancaster, United Kingdom
// All rights reserved
//
//------------------------------------------------------------------------------

#import <Foundation/Foundation.h>

#import <OpenCL/OpenCL.h>

@interface RRCLKernel : NSObject
{
	cl_kernel kernel;
}

- (id)initWithKernelName:(NSString *)kernelName inProgram:(cl_program)aProgram;

@end
