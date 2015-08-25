//
//  MTECurrencies.h
//  myTravelExpenses
//
//  Created by Stéphanie Meusling on 19.08.15.
//  Copyright (c) 2015 smeusling. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTECurrencies : NSObject

+ (MTECurrencies *)sharedInstance;

- (NSArray *)currencyCodes;
- (NSOrderedSet *)sections;
- (NSDictionary *)currencyCodesBySections;
- (NSString *)currencyNameForCode:(NSString *)code;
- (NSString *)currencyFullNameForCode:(NSString *)code;
- (NSString *)currencySymbolForCode:(NSString *)code;

+ (NSNumberFormatter *)formatter:(NSString *)currencyCode;
+ (NSNumberFormatter *)formatterNoCurrency10Digits:(NSString *)currencyCode;

@end
