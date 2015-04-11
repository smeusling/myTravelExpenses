//
//  Currency.m
//  myTravelExpenses
//
//  Created by Stéphanie Meusling on 11.04.15.
//  Copyright (c) 2015 smeusling. All rights reserved.
//

#import "Currency.h"

@implementation Currency

- (id)initWithName:(NSString *)name isPrimary:(BOOL)isPrimary
{
    self = [super init];
    if (self) {
        _name = name;
        _isPrimary = isPrimary;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:_name forKey:@"name"];
    [coder encodeBool:_isPrimary forKey:@"isPrimary"];
    
}

- (id)initWithCoder:(NSCoder *)coder;
{
    self = [super init];
    if (self != nil)
    {
        _name = [coder decodeObjectForKey:@"name"];
        _isPrimary = [coder decodeBoolForKey:@"isPrimary"];
    }
    return self;
}


@end
