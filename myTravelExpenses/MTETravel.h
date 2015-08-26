//
//  MTETravel.h
//  myTravelExpenses
//
//  Created by Stéphanie Meusling on 19.08.15.
//  Copyright (c) 2015 smeusling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MTEExchangeRate, MTEExpense;

@interface MTETravel : NSManagedObject

@property (nonatomic, retain) NSString * currencyCode;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * startDate;
@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) NSDecimalNumber * profileCurrencyRate;
@property (nonatomic, retain) NSSet *expenses;
@property (nonatomic, retain) NSSet *rates;

@end

@interface MTETravel (CoreDataGeneratedAccessors)

- (void)addExpensesObject:(MTEExpense *)value;
- (void)removeExpensesObject:(MTEExpense *)value;
- (void)addExpenses:(NSSet *)values;
- (void)removeExpenses:(NSSet *)values;

- (void)addRatesObject:(MTEExchangeRate *)value;
- (void)removeRatesObject:(MTEExchangeRate *)value;
- (void)addRates:(NSSet *)values;
- (void)removeRates:(NSSet *)values;

- (NSDecimalNumber *)totalAmount;
- (NSDecimalNumber *)totalAmountInProfileCurrency;

@end
