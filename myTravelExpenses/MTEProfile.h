//
//  Profile.h
//  myTravelExpenses
//
//  Created by Stéphanie Meusling on 04.04.15.
//  Copyright (c) 2015 smeusling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MTECurrency;
@interface MTEProfile : NSObject <NSCoding>

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) MTECurrency *currency;


- (id)initWithFirstName:(NSString *)firstName lastName:(NSString *)lastName image:(NSString*)image currency:(MTECurrency*)currency;

@end
