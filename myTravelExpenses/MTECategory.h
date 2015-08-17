//
//  MTECategory.h
//  myTravelExpenses
//
//  Created by Stéphanie Meusling on 17.08.15.
//  Copyright (c) 2015 smeusling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MTECategory : NSObject

@property (nonatomic, strong) NSString *categoryId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UIColor *color;

-(id)initWithId:(NSString *)categoryId name:(NSString *)name color:(NSString *)color;

@end
