// RROpenCL RRCLContext.h
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

#import <Foundation/Foundation.h>

#import <OpenCL/OpenCL.h>

@class RRCLCommandQueue;
@class RRCLProgram;
@class RRCLBuffer;

/*!
 * The RROpenCL framework does not overlay an additional layer of abstraction on
 * top of OpenCL, but merely to objectify the existing layer in Objective-C
 * terms.
 *
 * The difference is only one of styling and memory management. Both are
 * practical goals. Styling: because the natural interface to OpenCL is C-based,
 * and hence arguments do not naturally accept Foundation types such as
 * NSString, NSArray, etc. Memory management: because C-based objects live
 * outside the more natural memory management models built into Objective-C,
 * whether it be retain-release or garbage collected model.
 *
 * Wrapping OpenCL objects in Objective-C NSObject-derived classes makes them
 * accessible to and subject to advanced memory management. In parallel
 * environments, e.g. using blocks and Grand Central dispatch, putting objects
 * in view of the garbage collector can remove many implementation
 * headaches. Hence, the advantage of wrapping.
 */
@interface RRCLContext : NSObject
{
	cl_context context;
}

- (id)initWithDeviceIDs:(NSArray *)deviceIDs;

- (RRCLCommandQueue *)commandQueueForDeviceID:(cl_device_id)aDeviceID;

- (RRCLProgram *)programWithSource:(NSString *)source;

- (RRCLBuffer *)readWriteBufferWithSize:(size_t)size;
- (RRCLBuffer *)writeOnlyBufferWithSize:(size_t)size;
- (RRCLBuffer *)readOnlyBufferWithSize:(size_t)size;

@end
