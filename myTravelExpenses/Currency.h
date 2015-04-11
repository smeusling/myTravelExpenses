//
//  Currency.h
//  myTravelExpenses
//
//  Created by Stéphanie Meusling on 11.04.15.
//  Copyright (c) 2015 smeusling. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Currency : NSObject <NSCoding>

@property (strong, nonatomic) NSString *name;
@property (nonatomic) BOOL isPrimary;

- (id)initWithName:(NSString *)name isPrimary:(BOOL)isPrimary;


@end
