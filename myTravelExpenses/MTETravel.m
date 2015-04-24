//
//  Travel.m
//  myTravelExpenses
//
//  Created by Stéphanie Meusling on 04.04.15.
//  Copyright (c) 2015 smeusling. All rights reserved.
//

#import "MTETravel.h"
#import "MTECurrency.h"

@implementation MTETravel

- (id)initWithName:(NSString *)name startDate:(NSDate *)startDate endDate:(NSDate *)endDate image:(UIImage*)image currencies:(NSArray*)currencies
{
    self = [super init];
    if (self) {
        _name = name;
        _startDate = startDate;
        _endDate = endDate;
        _image = image;
        _currencies = currencies;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder;
{
    [coder encodeObject:_name forKey:@"name"];
    [coder encodeObject:_startDate forKey:@"startDate"];
    [coder encodeObject:_endDate forKey:@"endDate"];
    [coder encodeObject:_image forKey:@"image"];
    [coder encodeObject:_currencies forKey:@"currencies"];
    
}

- (id)initWithCoder:(NSCoder *)coder;
{
    self = [super init];
    if (self != nil)
    {
        _name = [coder decodeObjectForKey:@"name"];
        _startDate = [coder decodeObjectForKey:@"startDate"];
        _endDate = [coder decodeObjectForKey:@"endDate"];
        _image = [coder decodeObjectForKey:@"image"];
        _currencies = [coder decodeObjectForKey:@"currencies"];
    }
    return self;
}

- (MTECurrency *)primaryCurrency
{
    for (MTECurrency *currency in self.currencies) {
        if (currency.isPrimary){
            return currency;
        }
    }
    return nil;
}


@end
