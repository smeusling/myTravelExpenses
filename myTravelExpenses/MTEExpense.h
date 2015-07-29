//
//  MTEExpense.h
//  myTravelExpenses
//
//  Created by Stéphanie Meusling on 29.07.15.
//  Copyright (c) 2015 smeusling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MTECategory, MTETravel;

@interface MTEExpense : NSManagedObject

@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSString * currencyCode;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * uuid;
@property (nonatomic, retain) MTECategory *category;
@property (nonatomic, retain) MTETravel *travel;

@end
