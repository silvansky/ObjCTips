Objective-C Tips
================

Demo project that illustrates some of ObjC rarely used features.

1. Unnamed methods
2. Subscript methods for custom objects
3. `@property` syntax for non-property methods
4. Creating object without `alloc`/`init` (with `calloc`)
5. Print current autorelease pool
6. Synthesized ivars for `@property`
7. Accessing public ivars with `->`
8. instancetype keyword
9. Proxying other object with `forwardingTargetForSelector:` and `forwardInvocation:`
10. Using `NSFastEnumeration` to make `for..in` loop possible for custom objects

Project uses ARC and contains one custom class `TestObject` with all mentioned features in it. `main()` function show how this class can be used.

This code is distributed under MIT License. See `LICENSE` file for more info.
