//
//  NSNumber+PrimativeComparison.m
//  myTravelExpenses
//
//  Created by Stéphanie Meusling on 16.06.16.
//  Copyright © 2016 smeusling. All rights reserved.
//

#import "NSNumber+PrimativeComparison.h"

@implementation NSNumber (PrimativeComparison)

- (NSComparisonResult) compareWithInt:(int)i{
    return [self compare:[NSNumber numberWithInt:i]];
}

- (BOOL) isEqualToInt:(int)i{
    return [self compareWithInt:i] == NSOrderedSame;
}

- (BOOL) isGreaterThanInt:(int)i{
    return [self compareWithInt:i] == NSOrderedDescending;
}

- (BOOL) isGreaterThanOrEqualToInt:(int)i{
    return [self isGreaterThanInt:i] || [self isEqualToInt:i];
}

- (BOOL) isLessThanInt:(int)i{
    return [self compareWithInt:i] == NSOrderedAscending;
}

- (BOOL) isLessThanOrEqualToInt:(int)i{
    return [self isLessThanInt:i] || [self isEqualToInt:i];
}

@end
