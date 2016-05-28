//
//  NSNull+JSON.m
//  FOSinOC
//
//  Created by MoonSlides on 16/5/28.
//  Copyright © 2016年 李龑. All rights reserved.
//

#import "NSNull+JSON.h"

@implementation NSNull(JSON)
- (NSUInteger)length { return 0; }

- (NSInteger)integerValue { return 0; };

- (float)floatValue { return 0; };

- (NSString *)description { return @"0(NSNull)"; }

- (NSArray *)componentsSeparatedByString:(NSString *)separator { return @[]; }

- (id)objectForKey:(id)key { return nil; }

- (BOOL)boolValue { return NO; }

- (NSRange)rangeOfCharacterFromSet:(NSCharacterSet *)aSet{
    NSRange nullRange = {NSNotFound, 0};
    return nullRange;
}
@end
