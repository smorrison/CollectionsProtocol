//
//  NSArray+CollectionsProtocol.m
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

#import "NSArray+CollectionsProtocol.h"

@implementation NSArray (CollectionsProtocol)

- (void)do:(void (^)(id object))block {
    [self enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) 
    {
        block(object);
    }];    
}

- (void)do:(void (^)(id object))block separatedBy:(void (^)())otherBlock 
{
    __block NSUInteger count = [self count];
    [self enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
        block(object);
        if (index < count - 1) {
            otherBlock();
        }
    }];       
}

- (void)select:(BOOL (^)(id object))selectBlock do:(void (^)(id object))block 
{
    [self enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
        if (selectBlock(object)) {
            block(object);
        }
    }];       
}

- (void)reject:(BOOL (^)(id object))rejectBlock do:(void (^)(id object))block 
{
    [self enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
        if (!rejectBlock(object)) {
            block(object);
        }
    }];       
}

- (void)collect:(id (^)(id object))collectBlock do:(void (^)(id object))block 
{
    [self enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
        block(collectBlock(object));
    }];    
}

- (NSArray *)collect:(id (^)(id object))block 
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
    [self enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
        [array addObject:block(object)];
    }];
    return [[array copy] autorelease];
}

- (NSArray *)select:(BOOL (^)(id object))block 
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
    [self enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
        if (block(object)) {
            [array addObject:object];
        }
    }];
    return [[array copy] autorelease];
}

- (NSArray *)collect:(id (^)(id object))collectBlock select:(BOOL (^)(id object))selectBlock 
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
    [self enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
        id temp = collectBlock(object);
        if (selectBlock(temp)) {
            [array addObject:temp];
        }
    }];
    return [[array copy] autorelease];
}

- (NSArray *)select:(BOOL (^)(id object))selectBlock collect:(id (^)(id object))collectBlock 
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
    [self enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
        if (selectBlock(object)) {
            [array addObject:collectBlock(object)];
        }
    }];
    return [[array copy] autorelease];
}

- (NSArray *)reject:(BOOL (^)(id object))block 
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self count]];
    [self enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
        if (!block(object)) {
            [array addObject:object];
        }
    }];
    return [[array copy] autorelease];
}

- (BOOL)conform:(BOOL (^)(id object))block 
{
    __block BOOL result = YES;
    [self enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
        if (!block(object)) {
            result = NO;
            *stop = YES;
        }
    }];
    return result;
}

- (id)inject:(id)start into:(id (^)(id accumulator, id object))block 
{
    __block id result = [start retain];
    [self enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
        [result autorelease];
        result = [block(result, object) retain];
    }];
    return [result autorelease];
}

- (id)detect:(BOOL (^)(id object))block 
{
    return [self detect:block ifNone:nil];
}

- (id)detect:(BOOL (^)(id object))block ifNone:(id)defaultValue 
{
    __block id result = [defaultValue retain];
    [self enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
        if (block(object)) {
            [result autorelease];
            result = [object retain];
            *stop = YES;
        }
    }];
    return [result autorelease];
}

@end
