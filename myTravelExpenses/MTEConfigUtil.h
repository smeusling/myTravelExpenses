//
//  ConfigUtil.h
//  myTravelExpenses
//
//  Created by Stéphanie Meusling on 04.04.15.
//  Copyright (c) 2015 smeusling. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTEConfigUtil : NSObject

+ (NSString *)profileCurrencyCode;

+ (void)setProfileCurrencyCode:(NSString *)profileCurrencyCode;

@end
