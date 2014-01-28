//
//  TestObject.h
//  ObjCTips
//
//  Created by Valentine on 28.01.14.
//  Copyright (c) 2014 silvansky. All rights reserved.
//

@interface TestObject : NSObject <NSFastEnumeration>
{
@public
	int _field;
}

+ (instancetype):(int)value;

- (void):(int)a;

- (void):(int)a :(int)b;

- (int)value;
- (void)setValue:(int)value;

- (NSInteger)count;
- (void)setTitle:(NSString *)title;

- (id)objectAtIndexedSubscript:(NSUInteger)index;
- (void)setObject:(id)obj atIndexedSubscript:(NSUInteger)index;

- (id)objectForKeyedSubscript:(id)key;
- (void)setObject:(id)obj forKeyedSubscript:(id)key;

@end
