//
//  NSSetCollectionsProtocolTestCase.m
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

#import "NSSetCollectionsProtocolTestCase.h"
#import "NSSet+CollectionsProtocol.h"

@implementation NSSetCollectionsProtocolTestCase

- (void)setUp
{
    [super setUp];
    
    mset1 = [[NSMutableSet setWithCapacity:10] retain];
    mset2 = [[NSMutableSet setWithCapacity:10] retain];
    for (int i = 0; i < 10; i++) {
        id object = [NSNumber numberWithInteger:i + 1];
        [mset1 addObject:object];
        [mset2 addObject:[object description]];
    }
    set1 = [mset1 copy];
    set2 = [mset2 copy];
}

- (void)tearDown
{
    [mset1 release], mset1 = nil;
    [mset2 release], mset2 = nil;
    [set1 release], set1 = nil;
    [set2 release], set2 = nil;
    [super tearDown];
}


// All code under test must be linked into the Unit Test bundle
- (void)testDo
{
    __block int i = 0;
    [set1 do:^(id object){
        i += [(NSNumber *)object integerValue];
    }];
    STAssertEquals(i, (int)55, @"NSSet do:");
    
    i = 0;
    [mset1 do:^(id object){
        i += [(NSNumber *)object integerValue];
    }];
    STAssertEquals(i, (int)55, @"NSMutableSet do:");
}

- (void)testDoSeparatedBy
{
    __block NSMutableString *string = [NSMutableString string];
    [set2 do:^(id object){} separatedBy:^(void){ [string appendString:@"*"]; }];
    STAssertEqualObjects(string, @"*********", @"NSSet do:separatedBy:");
    
    string = [NSMutableString string];
    [mset2 do:^(id object){} separatedBy:^(void){ [string appendString:@"*"]; }];
    STAssertEqualObjects(string, @"*********", @"NSMutableSet do:separatedBy:");
}

- (void)testCollect
{
    NSSet *set = [set1 collect:^id (id object){ return [object description]; }];
    STAssertNotNil(set, @"NSSet collect: not nil");
    STAssertEqualObjects(set, set2, @"NSSet collect: result equals set of descriptions");
    
    set = [mset1 collect:^id (id object){ return [object description]; }];
    STAssertNotNil(set, @"NSMutableSet collect: not nil");
    STAssertEqualObjects(set, set2, @"NSMutableSet collect: result equals set of descriptions");
}

- (void)testSelect
{
    NSMutableSet *set_ = [NSMutableSet setWithCapacity:5];
    for (int i = 0; i < 5; i++) {
        [set_ addObject:[NSNumber numberWithInteger:(i * 2) + 1]];
    }
    
    NSSet *set = [set1 select:^BOOL (id object){ return ([(NSNumber *)object integerValue] % 2 == 1); }]; // i.e. all objects that are odd.
    STAssertNotNil(set, @"NSSet select: not nil");
    STAssertEquals([set count], (NSUInteger)5, @"NSSet select: count is 5");
    STAssertEqualObjects(set, [set_ copy], @"NSSet select: result equals set of odd numbers");
    
    set = [mset1 select:^BOOL (id object){ return ([(NSNumber *)object integerValue] % 2 == 1); }];
    STAssertNotNil(set, @"NSMutableSet collect: not nil");
    STAssertEquals([set count], (NSUInteger)5, @"NSMutableSet select: count is 5");
    STAssertEqualObjects(set, [set_ copy], @"NSMutableSet select: result equals set of odd numbers");
}

- (void)testCollectSelect 
{
    NSSet *set = [set1 collect:^id (id object){ return [object description]; } select:^BOOL (id object){ return [object isEqual:@"5"]; }];
    STAssertNotNil(set, @"NSSet collect:select: not nil");
    STAssertEquals([set count], (NSUInteger)1, @"NSSet collect:select: count is 1");
    STAssertEqualObjects(set, [NSSet setWithObject:@"5"], @"NSSet collect:select: result equals set of string @\"5\"");
    
    set = [mset1 collect:^id (id object){ return [object description]; } select:^BOOL (id object){ return [object isEqual:@"5"]; }];
    STAssertNotNil(set, @"NSMutableSet collect:select: not nil");
    STAssertEquals([set count], (NSUInteger)1, @"NSMutableSet collect:select: count is 1");
    STAssertEqualObjects(set, [NSSet setWithObject:@"5"], @"NSMutableSet collect:select: result equals set of string @\"5\"");
}

- (void)testSelectCollect 
{
    NSSet *set = [set1 select:^BOOL (id object){ return [object isEqual:[NSNumber numberWithInteger:5]]; } collect:^id (id object){ return [object description]; }];
    STAssertNotNil(set, @"NSSet select:collect: not nil");
    STAssertEquals([set count], (NSUInteger)1, @"NSSet select:collect: count is 1");
    STAssertEqualObjects(set, [NSSet setWithObject:@"5"], @"NSSet select:collect: result equals set of string @\"5\"");
    
    set = [mset1 select:^BOOL (id object){ return [object isEqual:[NSNumber numberWithInteger:5]]; } collect:^id (id object){ return [object description]; }];
    STAssertNotNil(set, @"NSMutableSet select:collect: not nil");
    STAssertEquals([set count], (NSUInteger)1, @"NSMutableSet select:collect: count is 1");
    STAssertEqualObjects(set, [NSSet setWithObject:@"5"], @"NSMutableSet select:collect: result equals set of string @\"5\"");
}

- (void)testReject
{
    NSMutableSet *set_ = [NSMutableSet setWithCapacity:5];
    for (int i = 0; i < 5; i++) {
        [set_ addObject:[NSNumber numberWithInteger:(i * 2) + 2]];
    }
    
    NSSet *set = [set1 reject:^BOOL (id object){ return ([(NSNumber *)object integerValue] % 2 == 1); }]; // i.e. all objects that are odd.
    STAssertNotNil(set, @"NSSet select: not nil");
    STAssertEquals([set count], (NSUInteger)5, @"NSSet select: count is 5");
    STAssertEqualObjects(set, [set_ copy], @"NSSet select: result equals set of even numbers");
    
    set = [mset1 reject:^BOOL (id object){ return ([(NSNumber *)object integerValue] % 2 == 1); }];
    STAssertNotNil(set, @"NSMutableSet collect: not nil");
    STAssertEquals([set count], (NSUInteger)5, @"NSMutableSet select: count is 5");
    STAssertEqualObjects(set, [set_ copy], @"NSMutableSet select: result equals set of even numbers");
}

- (void)testInjectInto
{
    NSNumber *number = [set1 inject:[NSNumber numberWithInt:0] into:^id(id accumulator, id object) { return [NSNumber numberWithInteger:[accumulator integerValue] + [object integerValue]]; }];
    STAssertNotNil(number, @"NSSet inject:into: not nil");
    STAssertEqualObjects(number, [NSNumber numberWithInteger:55], @"NSSet inject:into: result equals 55");
    
    number = [mset1 inject:[NSNumber numberWithInt:0] into:^id(id accumulator, id object) { return [NSNumber numberWithInteger:[accumulator integerValue] + [object integerValue]]; }];
    STAssertNotNil(number, @"NSMutableSet inject:into: not nil");
    STAssertEqualObjects(number, [NSNumber numberWithInteger:55], @"NSMutableSet inject:into: result equals 55");
}

- (void)testDetect
{
    // we detect for strings here because Cocoa has a feature where for some values, [NSNumber numberWithInteger:n] will return the 
    // same instance for two invocations with the same value of n. Presumably for relatively low values of n, there are enough 
    // instances created for this to make sense.
    // Later we want to test that the instance returned on a successful detect: is not the same instance we use for comparison, so 
    // we use the string sets instead of the NSNumber sets.
    id object = [[NSObject alloc] init];
    id number = @"5";
    id number2 = @"11";
    
    id result = [set2 detect:^BOOL (id object) { return [object isEqual:number]; }];
    STAssertNotNil(result, @"NSSet detect: result not nil");
    STAssertEqualObjects(result, number, @"NSSet detect: result isEqual: number");
    STAssertTrue(result != number, @"NSSet detect: result != number");
    result = [set2 detect:^BOOL (id object) { return [object isEqual:number2]; }];
    STAssertNil(result, @"NSSet detect: result is nil");
    result = [set2 detect:^BOOL (id object) { return [object isEqual:number2]; } ifNone:object];
    STAssertNotNil(result, @"NSSet detect: result not nil");
    STAssertEqualObjects(result, object, @"NSSet detect: result isEqual: object");
    STAssertTrue(result == object, @"NSSet detect: result == object");
    
    result = [mset2 detect:^BOOL (id object) { return [object isEqual:number]; }];
    STAssertNotNil(result, @"NSMutableSet detect: result not nil");
    STAssertEqualObjects(result, number, @"NSMutableSet detect: result isEqual: number");
    STAssertTrue(result != number, @"NSMutableSet detect: result != number");
    result = [set2 detect:^BOOL (id object) { return [object isEqual:number2]; }];
    STAssertNil(result, @"NSMutableSet detect: result is nil");
    result = [set2 detect:^BOOL (id object) { return [object isEqual:number2]; } ifNone:object];
    STAssertNotNil(result, @"NSMutableSet detect: result not nil");
    STAssertEqualObjects(result, object, @"NSMutableSet detect: result isEqual: object");
    STAssertTrue(result == object, @"NSMutableSet detect: result == object");
}

- (void)testConform
{
    BOOL result = [set1 conform:^BOOL(id object){ return [object isKindOfClass:[NSNumber class]]; }];
    STAssertTrue(result, @"NSSet conform: all objects are of type NSNumber");
    result = [set1 conform:^BOOL(id object){ return [object isKindOfClass:[NSString class]]; }];
    STAssertFalse(result, @"NSSet conform: not all objects are of type NSString");
    result = [set2 conform:^BOOL(id object){ return [(NSString *)object length] == 1; }]; // will fail on @"10"
    STAssertFalse(result, @"NSSet conform: not all objects are of length 1");
    
    result = [mset1 conform:^BOOL(id object){ return [object isKindOfClass:[NSNumber class]]; }];
    STAssertTrue(result, @"NSMutableSet conform: all objects are of type NSNumber");
    result = [mset1 conform:^BOOL(id object){ return [object isKindOfClass:[NSString class]]; }];
    STAssertFalse(result, @"NSMutableSet conform: not all objects are of type NSString");
    result = [mset2 conform:^BOOL(id object){ return [(NSString *)object length] == 1; }]; // will fail on @"10"
    STAssertFalse(result, @"NSMutableSet conform: not all objects are of length 1");
}

- (void)testSelectDo 
{
    NSMutableSet *set_ = [NSMutableSet setWithCapacity:5];
    for (int i = 0; i < 5; i++) {
        [set_ addObject:[NSNumber numberWithInteger:(i * 2) + 1]];
    } // { 1, 3, 5, 7, 9 }
    
    __block NSMutableSet *set2_ = [NSMutableSet setWithCapacity:5];
    [set1 select:^BOOL (id object){ return ([(NSNumber *)object integerValue] % 2 == 1); } do:^void(id object) { [set2_ addObject:object]; }]; // i.e. all objects that are odd.
    STAssertNotNil(set2_, @"NSSet select:do: not nil");
    STAssertEquals([set2_ count], (NSUInteger)5, @"NSSet select:do: count is 5");
    STAssertEqualObjects(set2_, [set_ copy], @"NSSet select:do: result equals set of odd numbers");
    
    set2_ = [NSMutableSet setWithCapacity:5];
    [mset1 select:^BOOL (id object){ return ([(NSNumber *)object integerValue] % 2 == 1); } do:^void(id object) { [set2_ addObject:object]; }]; // i.e. all objects that are odd.
    STAssertNotNil(set2_, @"NSMutableSet select:do: not nil");
    STAssertEquals([set2_ count], (NSUInteger)5, @"NSMutableSet select:do: count is 5");
    STAssertEqualObjects(set2_, [set_ copy], @"NSMutableSet select:do: result equals set of odd numbers");
}

- (void)testRejectDo 
{
    NSMutableSet *set_ = [NSMutableSet setWithCapacity:5];
    for (int i = 0; i < 5; i++) {
        [set_ addObject:[NSNumber numberWithInteger:(i * 2) + 1]];
    } // { 1, 3, 5, 7, 9 }
    
    __block NSMutableSet *set2_ = [NSMutableSet setWithCapacity:5];
    [set1 reject:^BOOL (id object){ return ([(NSNumber *)object integerValue] % 2 == 0); } do:^void(id object){ [set2_ addObject:object]; }]; // i.e. all objects that are odd.
    STAssertNotNil(set2_, @"NSSet select:do: not nil");
    STAssertEquals([set2_ count], (NSUInteger)5, @"NSSet select:do: count is 5");
    STAssertEqualObjects(set2_, [set_ copy], @"NSSet select:do: result equals set of odd numbers");
    
    set2_ = [NSMutableSet setWithCapacity:5];
    [mset1 reject:^BOOL (id object){ return ([(NSNumber *)object integerValue] % 2 == 0); } do:^void(id object){ [set2_ addObject:object]; }]; // i.e. all objects that are odd.
    STAssertNotNil(set2_, @"NSMutableSet select:do: not nil");
    STAssertEquals([set2_ count], (NSUInteger)5, @"NSMutableSet select:do: count is 5");
    STAssertEqualObjects(set2_, [set_ copy], @"NSMutableSet select:do: result equals set of odd numbers");
}

- (void)testCollectDo 
{
    __block NSMutableSet *set = [NSMutableSet setWithCapacity:5];
    [set1 collect:^id (id object){ return [object description]; } do:^void(id object){ [set addObject:object]; }]; // i.e. all objects as strings.
    STAssertNotNil(set, @"NSSet collect:do: not nil");
    STAssertEquals([set count], (NSUInteger)10, @"NSSet collect:do: count is 10");
    STAssertEqualObjects(set, [set2 copy], @"NSSet collect:do: result equals set of strings");
    
    set = [NSMutableSet setWithCapacity:5];
    [mset1 collect:^id (id object){ return [object description]; } do:^void(id object){ [set addObject:object]; }]; // i.e. all objects as strings.
    STAssertNotNil(set, @"NSMutableSet collect:do: not nil");
    STAssertEquals([set count], (NSUInteger)10, @"NSMutableSet collect:do: count is 10");
    STAssertEqualObjects(set, [set2 copy], @"NSMutableSet collect:do: result equals set of strings");  
}

@end
