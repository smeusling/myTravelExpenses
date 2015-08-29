//
//  NSString+EDAdditions.m
//  exodoc
//
//  Created by Vincent Fournié on 03.02.14.
//  Copyright (c) 2014 Epyx. All rights reserved.
//

#import "NSString+EDAdditions.h"

@implementation NSString (EDAdditions)

- (NSString *)ed_stringByAddingNewLines
{
    return [NSString stringWithFormat:@"%@\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", self];
}

@end
