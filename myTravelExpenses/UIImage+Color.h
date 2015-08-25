//
//  UIImage+Color.h
//  exodoc
//
//  Created by Vincent Fournié on 05.09.12.
//  Copyright (c) 2012 Epyx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Color)

+ (UIImage *)imageNamed:(NSString *)name withColor:(UIColor *)color;
- (UIImage *)imageWithColor:(UIColor *)color;

@end
