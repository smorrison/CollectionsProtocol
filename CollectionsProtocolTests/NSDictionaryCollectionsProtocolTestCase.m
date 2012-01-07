//
//  NSDictionaryCollectionsProtocolTestCase.m
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

#import "NSDictionaryCollectionsProtocolTestCase.h"
#import "NSDictionary+CollectionsProtocol.h"

@implementation NSDictionaryCollectionsProtocolTestCase

- (void)setUp
{
    [super setUp];
    mdict1 = [[NSMutableDictionary dictionaryWithObjectsAndKeys:@"foo", @"one", @"bar", @"two", @"baz", @"three", nil] retain];
    dict1 = [mdict1 copy];
}

- (void)tearDown
{
    [mdict1 release], mdict1 = nil;
    [dict1 release], dict1 = nil;
    [super tearDown];
}

// All code under test must be linked into the Unit Test bundle
- (void)testKeysAndValuesDo
{
    NSArray *value = [NSArray arrayWithObjects:@"one", @"foo", @"two", @"bar", @"three", @"baz", nil];
    
    __block NSMutableArray *array = [NSMutableArray arrayWithCapacity:[dict1 count] * 2];
    [dict1 keysAndValuesDo:^(id key, id value) { [array addObject:key]; [array addObject:value]; }];
    STAssertNotNil(array, @"NSDictionary keysAndValuesDo: array not nil");
    STAssertTrue([array count] == 6, @"NSDictionary keysAndValuesDo: array has six elements");
    STAssertEqualObjects(array, value, @"NSDictionary keysAndValuesDo: array is equal");

    array = [NSMutableArray arrayWithCapacity:[dict1 count] * 2];
    [mdict1 keysAndValuesDo:^(id key, id value) { [array addObject:key]; [array addObject:value]; }];
    STAssertNotNil(array, @"NSMutableDictionary keysAndValuesDo: array not nil");
    STAssertTrue([array count] == 6, @"NSMutableDictionary keysAndValuesDo: array has six elements");
    STAssertEqualObjects(array, value, @"NSMutableDictionary keysAndValuesDo: array is equal");
}

- (void)testKeysDo 
{
    NSArray *value = [NSArray arrayWithObjects:@"one", @"two", @"three", nil];
    
    __block NSMutableArray *array = [NSMutableArray arrayWithCapacity:[dict1 count]];
    [dict1 keysDo:^(id key) { [array addObject:key]; }];
    STAssertNotNil(array, @"NSDictionary keysDo: array not nil");
    STAssertTrue([array count] == 3, @"NSDictionary keysDo: array has 3 elements");
    STAssertEqualObjects(array, value, @"NSDictionary keysDo: array is equal");
    
    array = [NSMutableArray arrayWithCapacity:[dict1 count]];
    [mdict1 keysDo:^(id key) { [array addObject:key]; }];
    STAssertNotNil(array, @"NSMutableDictionary keysDo: array not nil");
    STAssertTrue([array count] == 3, @"NSMutableDictionary keysDo: array has 3 elements");
    STAssertEqualObjects(array, value, @"NSMutableDictionary keysDo: array is equal");
}

- (void)testValuesDo 
{
    NSArray *value = [NSArray arrayWithObjects:@"foo", @"bar", @"baz", nil];
    
    __block NSMutableArray *array = [NSMutableArray arrayWithCapacity:[dict1 count]];
    [dict1 valuesDo:^(id value) { [array addObject:value]; }];
    STAssertNotNil(array, @"NSDictionary valuesDo: array not nil");
    STAssertTrue([array count] == 3, @"NSDictionary valuesDo: array has 3 elements");
    STAssertEqualObjects(array, value, @"NSDictionary valuesDo: array is equal");
    
    array = [NSMutableArray arrayWithCapacity:[dict1 count]];
    [mdict1 valuesDo:^(id value) { [array addObject:value]; }];
    STAssertNotNil(array, @"NSMutableDictionary valuesDo: array not nil");
    STAssertTrue([array count] == 3, @"NSMutableDictionary valuesDo: array has 3 elements");
    STAssertEqualObjects(array, value, @"NSMutableDictionary valuesDo: array is equal");
}

@end
