//
//  MTEExchangeRateTransient.h
//  myTravelExpenses
//
//  Created by Stéphanie Meusling on 19.08.15.
//  Copyright (c) 2015 smeusling. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTEExchangeRateTransient : NSObject

@property (nonatomic, strong) NSDecimalNumber * rate;
@property (nonatomic, strong) NSString * currencyCode;

@end
