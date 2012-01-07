# Smalltalk enumeration methods for Objective-C

Adds the typical SmallTalk enumeration methods to NSArray, NSSet, and NSDictionary.

The usual suspects are `do:`, `select:`, `collect:`, but I also have `do:separatedBy:`, `inject:into:`, and friends.

##Example

Enumerating all elements of an array and printing their descriptions to stdout can be achieved with
``` objc
[array do:^(id each){ NSLog([each description]); }];
```

Which is not as nice as
```
array do: [:each | Transcript println:each toString].
```

But a whole lot nicer than
``` objc
[array enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop){ NSLog([each description]); }];
```

Likewise, `collect:` and `select:` provide methods for mapping and reducing respectively.
``` objc
NSArray *array = [NSArray arrayWithObjects:[NSNumber numberWithInteger:1], [NSNumber numberWithInteger:2], [NSNumber numberWithInteger:3], [NSNumber numberWithInteger:4], [NSNumber numberWithInteger:5], nil];
[array collect:^id(id each) { return [each description]; }]; // {@"1", @"2", @"3", @"4", @"5"}
[array select:^BOOL(id each) { return [each integerValue] % 2; }]; // {1, 3, 5}
```
#Requires

This code uses Objective-C blocks and therefore can only target Mac OSX 10.6 or better.
#License

Generic MIT License