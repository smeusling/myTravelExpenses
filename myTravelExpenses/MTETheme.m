//
//  Theme.m
//  myTravelExpenses
//
//  Created by Stéphanie Meusling on 10.04.15.
//  Copyright (c) 2015 smeusling. All rights reserved.
//

#import "MTETheme.h"
#import "MTEDefaultTheme.h"

@implementation MTEThemeManager

+ (id<MTETheme>)sharedTheme
{
    static id<MTETheme> sharedTheme = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedTheme = [[MTEDefaultTheme alloc] init];
    });
    
    return sharedTheme;
}

+ (void)customizeAppAppearance
{
    id<MTETheme> theme = [self sharedTheme];
    
    [[UINavigationBar appearance] setBarTintColor:[theme navBarTintColor]];
    [[UINavigationBar appearance] setTintColor:[theme navTintColor]];
    [[UINavigationBar appearance] setBarStyle:[theme navBarStyle]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                           NSFontAttributeName : [UIFont fontWithName:@"OpenSans" size:18]}];
    
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    //[[UITabBar appearance] setBackgroundColor:[theme tabBarTintColor]];
    //[[UITabBar appearance] setTranslucent:YES];
    [[UITabBar appearance] setBarTintColor:[theme tabBarTintColor]];
    //[[UIView appearanceWhenContainedIn:[UITabBar class], nil] setTintColor: [theme tabBarButtonColor]];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [theme tabBarButtonColor] }
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }
                                             forState:UIControlStateSelected];
}

@end
