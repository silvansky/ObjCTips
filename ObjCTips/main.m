//
//  main.m
//  ObjCTips
//
//  Created by Valentine on 28.01.14.
//  Copyright (c) 2014 silvansky. All rights reserved.
//

#import <objc/runtime.h>
#import "TestObject.h"

// _objc_autoreleasePoolPrint is internal for ObjC, but we can grab it anyway
extern void _objc_autoreleasePoolPrint(void);

int main(int argc, const char * argv[])
{
	@autoreleasepool
	{
		// Allocating object with unnamed selector
		TestObject *obj = [TestObject :10];

		// Accessing "setTitle:" without declaring a @property
		obj.title = @"Just an object";
		NSLog(@"Created obj: %@", obj);

		// Accessing public ivar with "->"
		obj->_field++;

		// Creating invocation with unnamed selector ":"
		NSMethodSignature *sig = [obj methodSignatureForSelector:@selector(:)];
		NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
		invocation.selector = @selector(:);
		invocation.target = obj;
		int arg = 7;
		[invocation setArgument:&arg atIndex:2];
		[invocation invoke];
		NSLog(@"Updated after invocation obj: %@", obj);

		// Accessing objectAtIndexedSubscript: method with modern ObjC syntax
		id a = obj[5];
		id b = obj[6];
		NSLog(@"a = %@, b = %@", a, b);

		// Accessing setObject:atIndexedSubscript: method with modern ObjC syntax
		obj[5] = b;
		obj[6] = a;
		NSLog(@"Updated after swapping obj: %@", obj);

		// Accessing setObject:forKeyedSubscript: method with modern ObjC syntax
		obj[@"a"] = a;
		obj[@"b"] = b;
		NSLog(@"Updated after setting keyed values obj: %@", obj);

		// Accessing object:forKeyedSubscript: method with modern ObjC syntax
		a = obj[@"b"];
		b = obj[@"a"];
		NSLog(@"a = %@, b = %@", a, b);

		// Getting forwardingTargetForSelector: to work
		NSArray *keys = [obj performSelector:@selector(allKeys)];
		NSLog(@"All keys: %@", keys);

		// Getting forwardInvocation: to work
		SEL sel = NSSelectorFromString(@"allDamnKeys");
		// -Wno-arc-performSelector-leaks is in project file
		keys = [obj performSelector:sel];
		NSLog(@"All damn keys: %@", keys);

		// Using NSFastEnumeration
		NSLog(@"Enumerating...");
		obj.value = 100;
		for (NSNumber *n in obj)
		{
			NSLog(@"n = %@", n);
		}

		// Calling unnamed method ":"
		[obj :5];
		NSLog(@"Updated obj: %@", obj);

		// Calling unnamed method "::"
		[obj :[a intValue] :[b intValue]];
		NSLog(@"Updated obj: %@", obj);

		// Accessing count method as if it was a @property
		NSInteger count = obj.count;
		NSLog(@"Count is %ld", count);


		// Using calloc to allocate and fill memory with zeros
		void *newObject = calloc(1, class_getInstanceSize([TestObject class]));

		// Setting isa
		Class *c = (Class *)newObject;
		c[0] = [TestObject class];

		// Using __bridge_transfer to ensure object will be dealloc'ed
		obj = (__bridge_transfer TestObject *)newObject;

		// Sending init to obj for further initializations
		obj = [obj init];

		// Accessing "setValue:" as if it was a @property
		obj.value = 5;
		obj.title = @"New calloc'ed object";
		NSLog(@"calloc'ed obj: %@", obj);

		// Printing current autorelease pool
		_objc_autoreleasePoolPrint();
	}
	return 0;
}
