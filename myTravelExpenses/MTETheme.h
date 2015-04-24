//
//  Theme.h
//  myTravelExpenses
//
//  Created by Stéphanie Meusling on 10.04.15.
//  Copyright (c) 2015 smeusling. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MTETheme <NSObject>

- (UIColor *)mainColor;
- (UIColor *)mainTextColor;
- (UIColor *)secondaryTextColor;

- (UIColor *)buttonColor;
- (UIColor *)tableViewHeaderColor;

- (UIColor *)navBarTintColor;               // Navigation bar tint color
- (UIColor *)navTintColor;                  // Navigation tint color (buttons color)
- (UIBarStyle)navBarStyle;                  // Navigation bar style (title + status bar color)

- (UIColor *)tabBarTintColor;

- (UIColor *)tableViewBackgroundColor;

@end

@interface MTEThemeManager : NSObject

+ (id<MTETheme>)sharedTheme;

+ (void)customizeAppAppearance;

@end
