//
//  ConfigUtil.m
//  myTravelExpenses
//
//  Created by Stéphanie Meusling on 04.04.15.
//  Copyright (c) 2015 smeusling. All rights reserved.
//

#import "MTEConfigUtil.h"
#import "MTEProfile.h"

@implementation MTEConfigUtil

+ (MTEProfile *)profile
{
    NSData *encodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:@"MTEProfile"];
    return [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
}

+ (void)setProfile:(MTEProfile*)profile
{
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:profile];
    [[NSUserDefaults standardUserDefaults] setObject:encodedObject forKey:@"MTEProfile"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

+ (NSArray *)travelDataTest
{
    NSArray *menuItems ;
    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
    NSData *savedArray = [currentDefaults objectForKey:@"MTETravelDataTest"];
    if (savedArray != nil){
        NSArray *oldArray = [NSKeyedUnarchiver unarchiveObjectWithData:savedArray];
        if (oldArray != nil) {
            menuItems = [[NSArray alloc] initWithArray:oldArray];
        } else {
            menuItems = [[NSArray alloc] init];
        }
    }
    return menuItems;
}

+ (void)setTravelDataTest:(NSArray *)travelDataTest;
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:travelDataTest] forKey:@"MTETravelDataTest"];
}

@end
