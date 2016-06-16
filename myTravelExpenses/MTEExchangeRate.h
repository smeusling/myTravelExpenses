//
//  MTEExchangeRate.h
//  myTravelExpenses
//
//  Created by Stéphanie Meusling on 19.08.15.
//  Copyright (c) 2015 smeusling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MTETravel;

@interface MTEExchangeRate : NSManagedObject

@property (nonatomic, retain) NSString * currencyCode;
@property (nonatomic, retain) NSString * travelCurrencyCode;
@property (nonatomic, retain) NSDecimalNumber * rate;
@property (nonatomic, retain) MTETravel *travel;

+ (void)getExchangeRatesForCurrency:(NSString *)fromCurrency toCurrency:(NSString *)toCurrency withCompletionHandler:(void (^)(float rate))rateBlock;

@end
