//
//  Theme.m
//  myTravelExpenses
//
//  Created by Stéphanie Meusling on 10.04.15.
//  Copyright (c) 2015 smeusling. All rights reserved.
//

#import "Theme.h"
#import "DefaultTheme.h"

@implementation ThemeManager

+ (id<Theme>)sharedTheme
{
    static id<Theme> sharedTheme = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedTheme = [[DefaultTheme alloc] init];
    });
    
    return sharedTheme;
}

+ (void)customizeAppAppearance
{
    id<Theme> theme = [self sharedTheme];
    
    [[UINavigationBar appearance] setBarTintColor:[theme navBarTintColor]];
    [[UINavigationBar appearance] setTintColor:[theme navTintColor]];
    [[UINavigationBar appearance] setBarStyle:[theme navBarStyle]];
    
    [[UITabBar appearance] setTintColor:[theme tabBarTintColor]];
}

@end
