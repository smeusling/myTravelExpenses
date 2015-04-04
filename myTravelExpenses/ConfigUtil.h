//
//  ConfigUtil.h
//  myTravelExpenses
//
//  Created by Stéphanie Meusling on 04.04.15.
//  Copyright (c) 2015 smeusling. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Profile;
@interface ConfigUtil : NSObject

+ (Profile *)profile;
+ (void)setProfile:(Profile*)profile;

+ (NSArray *)travelDataTest;
+ (void)setTravelDataTest:(NSArray *)travelDataTest;

@end
