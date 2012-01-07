//
//  NSSet+CollectionsProtocol.h
//  CollectionsProtocol
//
//  Created by Sean Morrison on 1/6/12.
//  Copyright (c) 2012. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy 
// of this software and associated documentation files (the "Software"), to deal 
// in the Software without restriction, including  without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
// copies of the Software, and to permit persons to whom the Software is 
// furnished to do so, subject to following conditions:
//
// The above copyright notice and this permission notice shall be included in 
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE 
// SOFTWARE.

#import <Foundation/Foundation.h>

@interface NSSet (CollectionsProtocol)
- (void)do:(void (^)(id object))block;
- (void)do:(void (^)(id object))block separatedBy:(void (^)())otherBlock;
- (void)select:(BOOL (^)(id object))selectBlock do:(void (^)(id object))block;
- (void)reject:(BOOL (^)(id object))rejectBlock do:(void (^)(id object))block;
- (void)collect:(id (^)(id object))collectBlock do:(void (^)(id object))block;
- (NSSet *)collect:(id (^)(id object))block;
- (NSSet *)select:(BOOL (^)(id object))block;
- (NSSet *)collect:(id (^)(id object))collectBlock select:(BOOL (^)(id object))selectBlock;
- (NSSet *)select:(BOOL (^)(id object))selectBlock collect:(id (^)(id object))collectBlock;
- (NSSet *)reject:(BOOL (^)(id object))block;
- (BOOL)conform:(BOOL (^)(id object))block;
- (id)inject:(id)start into:(id (^)(id accumulator, id object))block;
- (id)detect:(BOOL (^)(id object))block;
- (id)detect:(BOOL (^)(id object))block ifNone:(id)defaultValue;
@end
