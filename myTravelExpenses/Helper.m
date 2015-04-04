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
@implementation Helper

+ (void) initTravelDataTest
{
    Travel *japan = [[Travel alloc]initWithName:@"UEFA App" startDate:[NSDate date] endDate:[NSDate date] image:@"japon" currencies:@[@"CHF", @"JYN"] mainCurrency:@"JYN"];
    
    
    NSArray *travels = @[japan];
    
    [ConfigUtil setTravelDataTest:travels];
    
}

+ (void) initProfile
{
    Profile *profile = [[Profile alloc]initWithFirstName:@"Stéphanie" lastName:@"Meusling" image:@"image" currency:@"CHF"];
    
    [ConfigUtil setProfile:profile];
}


@end
