//
//  NSIndexPath+USGNSStringValue.h
//  
//
//  Created by M.Satori on 14.10.30.
//  Copyright (c) 2014 M.Satori All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSIndexPath (USGNSStringValue)

- (NSString*)stringValue;
+ (instancetype)indexPathFromString:(NSString*)str;

@end
