//
//  UIImage+Color.m
//  exodoc
//
//  Created by Vincent Fournié on 05.09.12.
//  Copyright (c) 2012 Epyx. All rights reserved.
//

#import "UIImage+Color.h"

@implementation UIImage (Color)

+ (UIImage *)imageNamed:(NSString *)name withColor:(UIColor *)color
{
    UIImage *srcImage = [UIImage imageNamed:name];
    return [srcImage imageWithColor:color];
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    // begin a new image context, to draw onto
    CGRect rect = CGRectMake( 0.f, 0.f, self.size.width, self.size.height );
    UIGraphicsBeginImageContext( rect.size );
//    UIGraphicsBeginImageContextWithOptions( rect.size, NO, self.scale );

    // get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();

    // translate/flip the graphics context (for transforming from CG* coords to UI* coords)
    CGContextScaleCTM( context, 1.0, -1.0 );
    CGContextTranslateCTM( context, 0, -rect.size.height );

//    CGContextSetBlendMode( context, kCGBlendModeMultiply );
    CGContextDrawImage( context, rect, self.CGImage );

    CGContextClipToMask( context, rect, self.CGImage );

    CGContextSetFillColorWithColor( context, [color CGColor] );

    CGContextFillRect(context, rect);

    // generate a new UIImage from the graphics context we drew onto
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    // return the color-burned image
    return coloredImg;
}

@end
