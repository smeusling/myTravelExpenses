//
//  ConfigUtil.m
//  myTravelExpenses
//
//  Created by Stéphanie Meusling on 04.04.15.
//  Copyright (c) 2015 smeusling. All rights reserved.
//

#import "MTEConfigUtil.h"


@implementation MTEConfigUtil

+ (NSString *)profileCurrencyCode {
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"MTEProfileCurrencyCode"];
}

+ (void)setProfileCurrencyCode:(NSString *)profileCurrencyCode {
    [[NSUserDefaults standardUserDefaults] setValue:profileCurrencyCode forKey:@"MTEProfileCurrencyCode"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
