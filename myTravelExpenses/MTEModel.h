//
//  MTEModel.h
//  myTravelExpenses
//
//  Created by Stéphanie Meusling on 24.04.15.
//  Copyright (c) 2015 smeusling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MTETravel;
@interface MTEModel : NSObject

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

+ (MTEModel *)sharedInstance;

- (void)saveContext;

- (MTETravel *)createTravel;
-(void)createTravelWithName:(NSString *)name startDate:(NSDate *)startDate endDate:(NSDate *)endDate image:(NSData *)image currencyCode:(NSString *)currencyCode;

@end
