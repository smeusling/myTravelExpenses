//
//  MTEExpense.h
//  myTravelExpenses
//
//  Created by Stéphanie Meusling on 24.04.15.
//  Copyright (c) 2015 smeusling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MTETravel;

@interface MTEExpense : NSManagedObject

@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) MTETravel *travel;

@end
