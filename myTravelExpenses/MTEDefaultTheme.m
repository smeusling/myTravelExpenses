//
//  DefaultTheme.m
//  myTravelExpenses
//
//  Created by Stéphanie Meusling on 10.04.15.
//  Copyright (c) 2015 smeusling. All rights reserved.
//

#import "MTEDefaultTheme.h"

//For example UIColorFromHex(0x2ECC71)
#define UIColorFromHex(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0]

@implementation MTEDefaultTheme

- (UIColor *)mainColor
{
    return [UIColor colorWithRed:0/255.f green:228/255.f blue:255/255.f alpha:1];
}

- (UIColor *)mainTextColor
{
    return [UIColor whiteColor];
}

- (UIColor *)secondaryTextColor
{
    return [UIColor darkTextColor];
}

- (UIColor *)buttonColor
{
    return [UIColor colorWithRed:76/255.f green:83/255.f blue:101/255.f alpha:1];
}

- (UIColor *)tableViewHeaderColor
{
    return [UIColor colorWithRed:0/255.f green:207/255.f blue:231/255.f alpha:1];
}
- (UIColor *)navBarTintColor
{
    return [self mainColor];
}

- (UIColor *)navTintColor
{
    return [UIColor whiteColor];
}

- (UIBarStyle)navBarStyle
{
    return UIBarStyleBlack;
}

- (UIColor *)tabBarTintColor
{
    return [UIColor colorWithRed:24/255.f green:211/255.f blue:233/255.f alpha:1];
}

- (UIColor *)tableViewBackgroundColor
{
    return [UIColor colorWithRed:248/255.0f green:248/255.0f blue:248/255.0f alpha:1.0f];
}

@end
