//
//  NSIndexPath+USGNSStringValue.m
//  
//
//  Created by M.Satori on 14.10.30.
//  Copyright (c) 2014 M.Satori All rights reserved.
//

#import "NSIndexPath+USGNSStringValue.h"

@implementation NSIndexPath (USGNSStringValue)

- (NSString*)stringValue
{
	NSMutableArray *array = @[].mutableCopy;
	
	for (NSUInteger i = 0; i < self.length; i++) {
		NSUInteger index = [self indexAtPosition:i];
		[array addObject:@(index)];
    }
	
	return [array componentsJoinedByString:@","];
}
+ (instancetype)indexPathFromString:(NSString*)str
{
	if (!str) {
		return nil;
	}
	
	NSArray *array = [str componentsSeparatedByString:@","];
	NSIndexPath *indexPath = [[NSIndexPath alloc] init];
	
	for (NSString *cmp in array) {
		NSUInteger index = [cmp integerValue];
		indexPath = [indexPath indexPathByAddingIndex:index];
	}
	
	return indexPath;
}

@end
