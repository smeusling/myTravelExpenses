//
//  Helper.m
//  myTravelExpenses
//
//  Created by Stéphanie Meusling on 04.04.15.
//  Copyright (c) 2015 smeusling. All rights reserved.
//

#import "MTEHelper.h"
#import "MTETravel.h"
#import "MTEProfile.h"
#import "MTEConfigUtil.h"
#import "MTECurrency.h"

@implementation MTEHelper

+ (void) initTravelDataTest
{
    MTECurrency *chf = [[MTECurrency alloc]initWithName:@"CHF" isPrimary:NO];
    MTECurrency *jyn = [[MTECurrency alloc]initWithName:@"JYN" isPrimary:YES];
    
    MTETravel *japan = [[MTETravel alloc]initWithName:@"UEFA App" startDate:[NSDate date] endDate:[NSDate date] image:[UIImage imageNamed:@"japon"] currencies:@[chf, jyn]];
    
    
    NSArray *travels = @[japan];
    
    [MTEConfigUtil setTravelDataTest:travels];
    
}

+ (void) initProfile
{
    MTECurrency *chf = [[MTECurrency alloc]initWithName:@"CHF" isPrimary:NO];
    MTEProfile *profile = [[MTEProfile alloc]initWithFirstName:@"Stéphanie" lastName:@"Meusling" image:@"image" currency:chf];
    
    [MTEConfigUtil setProfile:profile];
}


@end
