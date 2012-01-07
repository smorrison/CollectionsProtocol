//
//  NSArrayCollectionsProtocolTests.m
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

#import "NSArrayCollectionsProtocolTestCase.h"
#import "NSArray+CollectionsProtocol.h"

@implementation NSArrayCollectionsProtocolTestCase

- (void)setUp
{
    [super setUp];
    
    marray1 = [[NSMutableArray arrayWithCapacity:10] retain];
    marray2 = [[NSMutableArray arrayWithCapacity:10] retain];
    for (int i = 0; i < 10; i++) {
        id object = [NSNumber numberWithInteger:i + 1];
        [marray1 addObject:object];
        [marray2 addObject:[object description]];
    }
    array1 = [marray1 copy];
    array2 = [marray2 copy];
}

- (void)tearDown
{
    [marray1 release], marray1 = nil;
    [marray2 release], marray2 = nil;
    [array1 release], array1 = nil;
    [array2 release], array2 = nil;
    [super tearDown];
}


// All code under test must be linked into the Unit Test bundle
- (void)testDo
{
    __block int i = 0;
    [array1 do:^(id object){
        i += [(NSNumber *)object integerValue];
    }];
    STAssertEquals(i, (int)55, @"NSArray do:");
    
    i = 0;
    [marray1 do:^(id object){
        i += [(NSNumber *)object integerValue];
    }];
    STAssertEquals(i, (int)55, @"NSMutableArray do:");
}

- (void)testDoSeparatedBy
{
    __block NSMutableString *string = [NSMutableString string];
    [array2 do:^(id object){ [string appendString:object]; } separatedBy:^(void){ [string appendString:@", "]; }];
    STAssertEqualObjects(string, @"1, 2, 3, 4, 5, 6, 7, 8, 9, 10", @"NSArray do:separatedBy:");
    
    string = [NSMutableString string];
    [marray2 do:^(id object){ [string appendString:object]; } separatedBy:^(void){ [string appendString:@", "]; }];
    STAssertEqualObjects(string, @"1, 2, 3, 4, 5, 6, 7, 8, 9, 10", @"NSMutableArray do:separatedBy:");
}

- (void)testCollect
{
    NSArray *array = [array1 collect:^id (id object){ return [object description]; }];
    STAssertNotNil(array, @"NSArray collect: not nil");
    STAssertEqualObjects(array, array2, @"NSArray collect: result equals array of descriptions");
    
    array = [marray1 collect:^id (id object){ return [object description]; }];
    STAssertNotNil(array, @"NSMutableArray collect: not nil");
    STAssertEqualObjects(array, array2, @"NSMutableArray collect: result equals array of descriptions");
}

- (void)testSelect
{
    NSMutableArray *array_ = [NSMutableArray arrayWithCapacity:5];
    for (int i = 0; i < 5; i++) {
        [array_ addObject:[NSNumber numberWithInteger:(i * 2) + 1]];
    }
    
    NSArray *array = [array1 select:^BOOL (id object){ return ([(NSNumber *)object integerValue] % 2 == 1); }]; // i.e. all objects that are odd.
    STAssertNotNil(array, @"NSArray select: not nil");
    STAssertEquals([array count], (NSUInteger)5, @"NSArray select: count is 5");
    STAssertEqualObjects(array, [array_ copy], @"NSArray select: result equals array of odd numbers");
    
    array = [marray1 select:^BOOL (id object){ return ([(NSNumber *)object integerValue] % 2 == 1); }];
    STAssertNotNil(array, @"NSMutableArray collect: not nil");
    STAssertEquals([array count], (NSUInteger)5, @"NSMutableArray select: count is 5");
    STAssertEqualObjects(array, [array_ copy], @"NSMutableArray select: result equals array of odd numbers");
}

- (void)testCollectSelect 
{
    NSArray *array = [array1 collect:^id (id object){ return [object description]; } select:^BOOL (id object){ return [object isEqual:@"5"]; }];
    STAssertNotNil(array, @"NSArray collect:select: not nil");
    STAssertEquals([array count], (NSUInteger)1, @"NSArray collect:select: count is 1");
    STAssertEqualObjects(array, [NSArray arrayWithObject:@"5"], @"NSArray collect:select: result equals array of string @\"5\"");

    array = [marray1 collect:^id (id object){ return [object description]; } select:^BOOL (id object){ return [object isEqual:@"5"]; }];
    STAssertNotNil(array, @"NSMutableArray collect:select: not nil");
    STAssertEquals([array count], (NSUInteger)1, @"NSMutableArray collect:select: count is 1");
    STAssertEqualObjects(array, [NSArray arrayWithObject:@"5"], @"NSMutableArray collect:select: result equals array of string @\"5\"");
}

- (void)testSelectCollect 
{
    NSArray *array = [array1 select:^BOOL (id object){ return [object isEqual:[NSNumber numberWithInteger:5]]; } collect:^id (id object){ return [object description]; }];
    STAssertNotNil(array, @"NSArray select:collect: not nil");
    STAssertEquals([array count], (NSUInteger)1, @"NSArray select:collect: count is 1");
    STAssertEqualObjects(array, [NSArray arrayWithObject:@"5"], @"NSArray select:collect: result equals array of string @\"5\"");
    
    array = [marray1 select:^BOOL (id object){ return [object isEqual:[NSNumber numberWithInteger:5]]; } collect:^id (id object){ return [object description]; }];
    STAssertNotNil(array, @"NSMutableArray select:collect: not nil");
    STAssertEquals([array count], (NSUInteger)1, @"NSMutableArray select:collect: count is 1");
    STAssertEqualObjects(array, [NSArray arrayWithObject:@"5"], @"NSMutableArray select:collect: result equals array of string @\"5\"");
}

- (void)testReject
{
    NSMutableArray *array_ = [NSMutableArray arrayWithCapacity:5];
    for (int i = 0; i < 5; i++) {
        [array_ addObject:[NSNumber numberWithInteger:(i * 2) + 2]];
    }
    
    NSArray *array = [array1 reject:^BOOL (id object){ return ([(NSNumber *)object integerValue] % 2 == 1); }]; // i.e. all objects that are odd.
    STAssertNotNil(array, @"NSArray select: not nil");
    STAssertEquals([array count], (NSUInteger)5, @"NSArray select: count is 5");
    STAssertEqualObjects(array, [array_ copy], @"NSArray select: result equals array of even numbers");
    
    array = [marray1 reject:^BOOL (id object){ return ([(NSNumber *)object integerValue] % 2 == 1); }];
    STAssertNotNil(array, @"NSMutableArray collect: not nil");
    STAssertEquals([array count], (NSUInteger)5, @"NSMutableArray select: count is 5");
    STAssertEqualObjects(array, [array_ copy], @"NSMutableArray select: result equals array of even numbers");
}

- (void)testInjectInto
{
    NSNumber *number = [array1 inject:[NSNumber numberWithInt:0] into:^id(id accumulator, id object) { return [NSNumber numberWithInteger:[accumulator integerValue] + [object integerValue]]; }];
    STAssertNotNil(number, @"NSArray inject:into: not nil");
    STAssertEqualObjects(number, [NSNumber numberWithInteger:55], @"NSArray inject:into: result equals 55");

    number = [marray1 inject:[NSNumber numberWithInt:0] into:^id(id accumulator, id object) { return [NSNumber numberWithInteger:[accumulator integerValue] + [object integerValue]]; }];
    STAssertNotNil(number, @"NSMutableArray inject:into: not nil");
    STAssertEqualObjects(number, [NSNumber numberWithInteger:55], @"NSMutableArray inject:into: result equals 55");
}

- (void)testDetect
{
    // we detect for strings here because Cocoa has a feature where for some values, [NSNumber numberWithInteger:n] will return the 
    // same instance for two invocations with the same value of n. Presumably for relatively low values of n, there are enough 
    // instances created for this to make sense.
    // Later we want to test that the instance returned on a successful detect: is not the same instance we use for comparison, so 
    // we use the string arrays instead of the NSNumber arrays.
    id object = [[NSObject alloc] init];
    id number = @"5";
    id number2 = @"11";
    
    id result = [array2 detect:^BOOL (id object) { return [object isEqual:number]; }];
    STAssertNotNil(result, @"NSArray detect: result not nil");
    STAssertEqualObjects(result, number, @"NSArray detect: result isEqual: number");
    STAssertTrue(result != number, @"NSArray detect: result != number");
    result = [array2 detect:^BOOL (id object) { return [object isEqual:number2]; }];
    STAssertNil(result, @"NSArray detect: result is nil");
    result = [array2 detect:^BOOL (id object) { return [object isEqual:number2]; } ifNone:object];
    STAssertNotNil(result, @"NSArray detect: result not nil");
    STAssertEqualObjects(result, object, @"NSArray detect: result isEqual: object");
    STAssertTrue(result == object, @"NSArray detect: result == object");

    result = [marray2 detect:^BOOL (id object) { return [object isEqual:number]; }];
    STAssertNotNil(result, @"NSMutableArray detect: result not nil");
    STAssertEqualObjects(result, number, @"NSMutableArray detect: result isEqual: number");
    STAssertTrue(result != number, @"NSMutableArray detect: result != number");
    result = [array2 detect:^BOOL (id object) { return [object isEqual:number2]; }];
    STAssertNil(result, @"NSMutableArray detect: result is nil");
    result = [array2 detect:^BOOL (id object) { return [object isEqual:number2]; } ifNone:object];
    STAssertNotNil(result, @"NSMutableArray detect: result not nil");
    STAssertEqualObjects(result, object, @"NSMutableArray detect: result isEqual: object");
    STAssertTrue(result == object, @"NSMutableArray detect: result == object");
}

- (void)testConform
{
    BOOL result = [array1 conform:^BOOL(id object){ return [object isKindOfClass:[NSNumber class]]; }];
    STAssertTrue(result, @"NSArray conform: all objects are of type NSNumber");
    result = [array1 conform:^BOOL(id object){ return [object isKindOfClass:[NSString class]]; }];
    STAssertFalse(result, @"NSArray conform: not all objects are of type NSString");
    result = [array2 conform:^BOOL(id object){ return [(NSString *)object length] == 1; }]; // will fail on @"10"
    STAssertFalse(result, @"NSArray conform: not all objects are of length 1");

    result = [marray1 conform:^BOOL(id object){ return [object isKindOfClass:[NSNumber class]]; }];
    STAssertTrue(result, @"NSMutableArray conform: all objects are of type NSNumber");
    result = [marray1 conform:^BOOL(id object){ return [object isKindOfClass:[NSString class]]; }];
    STAssertFalse(result, @"NSMutableArray conform: not all objects are of type NSString");
    result = [marray2 conform:^BOOL(id object){ return [(NSString *)object length] == 1; }]; // will fail on @"10"
    STAssertFalse(result, @"NSMutableArray conform: not all objects are of length 1");
}

- (void)testSelectDo 
{
    NSMutableArray *array_ = [NSMutableArray arrayWithCapacity:5];
    for (int i = 0; i < 5; i++) {
        [array_ addObject:[NSNumber numberWithInteger:(i * 2) + 1]];
    } // { 1, 3, 5, 7, 9 }
    
    __block NSMutableArray *array2_ = [NSMutableArray arrayWithCapacity:5];
    [array1 select:^BOOL (id object){ return ([(NSNumber *)object integerValue] % 2 == 1); } do:^void(id object) { [array2_ addObject:object]; }]; // i.e. all objects that are odd.
    STAssertNotNil(array2_, @"NSArray select:do: not nil");
    STAssertEquals([array2_ count], (NSUInteger)5, @"NSArray select:do: count is 5");
    STAssertEqualObjects(array2_, [array_ copy], @"NSArray select:do: result equals array of odd numbers");
 
    array2_ = [NSMutableArray arrayWithCapacity:5];
    [marray1 select:^BOOL (id object){ return ([(NSNumber *)object integerValue] % 2 == 1); } do:^void(id object) { [array2_ addObject:object]; }]; // i.e. all objects that are odd.
    STAssertNotNil(array2_, @"NSMutableArray select:do: not nil");
    STAssertEquals([array2_ count], (NSUInteger)5, @"NSMutableArray select:do: count is 5");
    STAssertEqualObjects(array2_, [array_ copy], @"NSMutableArray select:do: result equals array of odd numbers");
}

- (void)testRejectDo 
{
    NSMutableArray *array_ = [NSMutableArray arrayWithCapacity:5];
    for (int i = 0; i < 5; i++) {
        [array_ addObject:[NSNumber numberWithInteger:(i * 2) + 1]];
    } // { 1, 3, 5, 7, 9 }
    
    __block NSMutableArray *array2_ = [NSMutableArray arrayWithCapacity:5];
    [array1 reject:^BOOL (id object){ return ([(NSNumber *)object integerValue] % 2 == 0); } do:^void(id object){ [array2_ addObject:object]; }]; // i.e. all objects that are odd.
    STAssertNotNil(array2_, @"NSArray select:do: not nil");
    STAssertEquals([array2_ count], (NSUInteger)5, @"NSArray select:do: count is 5");
    STAssertEqualObjects(array2_, [array_ copy], @"NSArray select:do: result equals array of odd numbers");
    
    array2_ = [NSMutableArray arrayWithCapacity:5];
    [marray1 reject:^BOOL (id object){ return ([(NSNumber *)object integerValue] % 2 == 0); } do:^void(id object){ [array2_ addObject:object]; }]; // i.e. all objects that are odd.
    STAssertNotNil(array2_, @"NSMutableArray select:do: not nil");
    STAssertEquals([array2_ count], (NSUInteger)5, @"NSMutableArray select:do: count is 5");
    STAssertEqualObjects(array2_, [array_ copy], @"NSMutableArray select:do: result equals array of odd numbers");
}

- (void)testCollectDo 
{
    __block NSMutableArray *array = [NSMutableArray arrayWithCapacity:5];
    [array1 collect:^id (id object){ return [object description]; } do:^void(id object){ [array addObject:object]; }]; // i.e. all objects as strings.
    STAssertNotNil(array, @"NSArray collect:do: not nil");
    STAssertEquals([array count], (NSUInteger)10, @"NSArray collect:do: count is 10");
    STAssertEqualObjects(array, [array2 copy], @"NSArray collect:do: result equals array of strings");
    
    array = [NSMutableArray arrayWithCapacity:5];
    [marray1 collect:^id (id object){ return [object description]; } do:^void(id object){ [array addObject:object]; }]; // i.e. all objects as strings.
    STAssertNotNil(array, @"NSMutableArray collect:do: not nil");
    STAssertEquals([array count], (NSUInteger)10, @"NSMutableArray collect:do: count is 10");
    STAssertEqualObjects(array, [array2 copy], @"NSMutableArray collect:do: result equals array of strings");  
}
@end
