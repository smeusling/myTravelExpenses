//
//  MTEModel.h
//  myTravelExpenses
//
//  Created by Stéphanie Meusling on 24.04.15.
//  Copyright (c) 2015 smeusling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MTETravel, MTEExpense, MTEExchangeRate;
@interface MTEModel : NSObject

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

+ (MTEModel *)sharedInstance;

- (void)saveContext;

- (MTETravel *)createTravel;
- (MTETravel *)createTravelWithName:(NSString *)name startDate:(NSDate *)startDate endDate:(NSDate *)endDate image:(NSData *)image currencyCode:(NSString *)currencyCode;

-(MTETravel *)updateTravel:(MTETravel *)travel name:(NSString *)name startDate:(NSDate *)startDate endDate:(NSDate *)endDate image:(NSData *)image currencyCode:(NSString *)currencyCode;

- (MTEExpense *)createExpenseWithName:(NSString *)name date:(NSDate *)date amount:(NSDecimalNumber *)amount travel:(MTETravel *)travel currencyCode:(NSString *)currencyCode categoryId:(NSString *)categoryId;

- (MTEExchangeRate *)addExchangeRate:(MTETravel *)travel currencyCode:(NSString *)currencyCode rate:(NSDecimalNumber *)rate;

@end
