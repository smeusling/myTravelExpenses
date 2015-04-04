//
//  Profile.m
//  myTravelExpenses
//
//  Created by Stéphanie Meusling on 04.04.15.
//  Copyright (c) 2015 smeusling. All rights reserved.
//

#import "Profile.h"

@implementation Profile


- (id)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName image:(NSString*)image currency:(NSString*)currency;
{
    self = [super init];
    if (self) {
        _firstName = firstName;
        _lastName = lastName;
        _image = image;
        _currency = currency;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:_firstName forKey:@"firstName"];
    [coder encodeObject:_lastName forKey:@"lastName"];
    [coder encodeObject:_image forKey:@"image"];
    [coder encodeObject:_currency forKey:@"currency"];
    
}

- (id)initWithCoder:(NSCoder *)coder;
{
    self = [super init];
    if (self != nil)
    {
        _firstName = [coder decodeObjectForKey:@"firstName"];
        _lastName = [coder decodeObjectForKey:@"lastName"];
        _image = [coder decodeObjectForKey:@"image"];
        _currency = [coder decodeObjectForKey:@"currency"];
    }
    return self;
}
@end
