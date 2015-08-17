//
//  MTECategory.m
//  myTravelExpenses
//
//  Created by Stéphanie Meusling on 17.08.15.
//  Copyright (c) 2015 smeusling. All rights reserved.
//

#import "MTECategory.h"
#import "UIColor+HexColors.h"

@implementation MTECategory

-(id)initWithId:(NSString *)categoryId name:(NSString *)name color:(NSString *)color
{
    self = [super init];
    if (self){
        _categoryId = categoryId;
        _name = name;
        _color = [UIColor colorWithHexString:color];
    }
    return self;
}

@end
