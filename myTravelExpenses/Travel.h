//
//  Travel.h
//  myTravelExpenses
//
//  Created by Stéphanie Meusling on 04.04.15.
//  Copyright (c) 2015 smeusling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Currency;
@interface Travel : NSObject <NSCoding>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSArray *currencies;


- (id)initWithName:(NSString *)name startDate:(NSDate *)startDate endDate:(NSDate *)endDate image:(UIImage*)image currencies:(NSArray*)currencies;

- (Currency *)primaryCurrency;


@end
