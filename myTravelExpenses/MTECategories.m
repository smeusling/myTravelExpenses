//
//  MTECategories.m
//  myTravelExpenses
//
//  Created by Stéphanie Meusling on 17.08.15.
//  Copyright (c) 2015 smeusling. All rights reserved.
//

#import "MTECategories.h"
#import "MTECategory.h"

@interface MTECategories()

@property (nonatomic, strong) NSMutableArray *allCategories;

@end


@implementation MTECategories

+ (MTECategories *)sharedCategories
{
    static MTECategories *categories;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        categories = [[MTECategories alloc] init];
        
        NSString* filePath = [[NSBundle mainBundle] pathForResource:@"MTECategoriesList"
                                                             ofType:@"plist"];
        
        NSArray* plist = [NSArray arrayWithContentsOfFile:filePath];
        
        categories.allCategories = [[NSMutableArray alloc]init];
        
        for (NSDictionary *dict in plist) {
            MTECategory *cat = [[MTECategory alloc]initWithId:[dict objectForKey:@"id"] name:[dict objectForKey:@"name"] color:[dict objectForKey:@"color"]];
            [categories.allCategories addObject:cat];
        }
    });
    
    return categories;
}

- (NSArray *)categories
{
    return self.allCategories.copy;
}

- (MTECategory *)categoryById:(NSString *)categoryId
{
    for (MTECategory *cat in self.allCategories) {
        if([cat.categoryId isEqualToString:categoryId]){
            return cat;
        }
    }
    return nil;
}

@end
