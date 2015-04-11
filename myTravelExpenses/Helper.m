//
//  Helper.m
//  myTravelExpenses
//
//  Created by Stéphanie Meusling on 04.04.15.
//  Copyright (c) 2015 smeusling. All rights reserved.
//

#import "Helper.h"
#import "Travel.h"
#import "Profile.h"
#import "ConfigUtil.h"
#import "Currency.h"

@implementation Helper

+ (void) initTravelDataTest
{
    Currency *chf = [[Currency alloc]initWithName:@"CHF" isPrimary:NO];
    Currency *jyn = [[Currency alloc]initWithName:@"JYN" isPrimary:YES];
    
    Travel *japan = [[Travel alloc]initWithName:@"UEFA App" startDate:[NSDate date] endDate:[NSDate date] image:[UIImage imageNamed:@"japon"] currencies:@[chf, jyn]];
    
    
    NSArray *travels = @[japan];
    
    [ConfigUtil setTravelDataTest:travels];
    
}

+ (void) initProfile
{
    Currency *chf = [[Currency alloc]initWithName:@"CHF" isPrimary:NO];
    Profile *profile = [[Profile alloc]initWithFirstName:@"Stéphanie" lastName:@"Meusling" image:@"image" currency:chf];
    
    [ConfigUtil setProfile:profile];
}


@end
