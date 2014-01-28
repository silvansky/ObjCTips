//
//  TestObject.m
//  ObjCTips
//
//  Created by Valentine on 28.01.14.
//  Copyright (c) 2014 silvansky. All rights reserved.
//

#import "TestObject.h"
#import <objc/runtime.h>

@interface TestObject ()

- (void)refillValues;

@property (atomic, strong) NSString *internalTitle;
@property (atomic, strong) NSMutableDictionary *dict;

@end

@implementation TestObject
{
	int _value;
	int *_values;
}

#pragma mark - Inherited

- (void)dealloc
{
	free(_values);
}

- (NSString *)description
{
	NSMutableString *values = [NSMutableString stringWithString:@""];
	if (_value)
	{
		values = [NSMutableString stringWithFormat:@"%d", _values[0]];
		for (int i = 1; i < _value; ++i)
		{
			[values appendFormat:@", %d", _values[i]];
		}
	}
	return [NSString stringWithFormat:@"%@ { title : \"%@\", _field: %d, _value : %d, _values : %p (%@), dict : %@ }", [super description], self.internalTitle, _field, _value, _values, values, self.dict];
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
	if ([_dict respondsToSelector:aSelector])
	{
		return _dict;
	}
	return [super forwardingTargetForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
	if ([NSStringFromSelector(anInvocation.selector) isEqualToString:@"allDamnKeys"])
	{
		anInvocation.selector = @selector(allKeys);
		[anInvocation invokeWithTarget:_dict];
	}
	else
	{
		[super forwardInvocation:anInvocation];
	}
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
	NSMethodSignature *sig = [super methodSignatureForSelector:aSelector];
	if ([NSStringFromSelector(aSelector) isEqualToString:@"allDamnKeys"])
	{
		sig = [_dict methodSignatureForSelector:@selector(allKeys)];
	}
	return sig;
}


#pragma mark - Own

+ (TestObject *):(int)value
{
	TestObject *obj = [TestObject new];
	obj.value = value;

	return obj;
}

- (void):(int)a
{
	self.value = a;
}

- (void):(int)a :(int)b
{
	self.value = a + b;
}

- (int)value
{
	return _value;
}

- (void)setValue:(int)value
{
	_value = value;
	[self refillValues];
}

- (NSInteger)count
{
	return _value;
}

- (void)setTitle:(NSString *)title
{
	self.internalTitle = title;
}

- (id)objectAtIndexedSubscript:(NSUInteger)index
{
	return @(_values[index]);
}

- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)index
{
	_values[index] = [obj intValue];
}

- (id)objectForKeyedSubscript:(id)key
{
	return _dict[key];
}

- (void)setObject:(id)obj forKeyedSubscript:(id)key
{
	if (!_dict)
	{
		_dict = [NSMutableDictionary new];
	}

	_dict[key] = obj;
}

#pragma mark - Private

- (void)refillValues
{
	free(_values);
	_values = malloc(sizeof(int) * _value);
	for (int i = 0; i < _value; ++i)
	{
		_values[i] = i;
	}
}

#pragma mark - NSFastEnumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len
{
	if (state->state >= _value)
	{
		return 0;
	}
	NSUInteger itemsToGive = MIN(len, _value - state->state);
	for (NSUInteger i = 0; i < itemsToGive; ++i)
	{
		buffer[i] = @(_values[i + state->state]);
	}
	state->itemsPtr = buffer;
	state->mutationsPtr = &state->extra[0];
	state->state += itemsToGive;
	return itemsToGive;
}

@end
