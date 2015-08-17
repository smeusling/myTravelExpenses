//
//  MTECategories.h
//  myTravelExpenses
//
//  Created by Stéphanie Meusling on 17.08.15.
//  Copyright (c) 2015 smeusling. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MTECategory;

@interface MTECategories : NSObject

+ (MTECategories *)sharedCategories;

- (NSArray *)categories;
- (MTECategory *)categoryById:(NSString *)categoryId;

@end
