//
//  MTETravelTabBarController.m
//  myTravelExpenses
//
//  Created by Stéphanie Meusling on 25.08.15.
//  Copyright (c) 2015 smeusling. All rights reserved.
//

#import "MTETravelTabBarController.h"
#import "UIImage+Color.h"
#import "MTETheme.h"

@interface MTETravelTabBarController ()

@end

@implementation MTETravelTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITabBarItem *catItem = [self.tabBar.items objectAtIndex:0];
    UITabBarItem *dailyItem = [self.tabBar.items objectAtIndex:1];
    UITabBarItem *editItem = [self.tabBar.items objectAtIndex:2];
    
    UIImage *catImageSelected = [UIImage imageNamed:@"tab-pie.png"];
    UIImage *dailyImageSelected = [UIImage imageNamed:@"tab-daily.png"];
    UIImage *editImageSelected = [UIImage imageNamed:@"tab-edit.png"];
    
    UIColor *color = [[MTEThemeManager sharedTheme] tabBarButtonColor];
    
    UIImage *catImage = [catImageSelected imageWithColor:color];
    UIImage *dailyImage = [dailyImageSelected imageWithColor:color];
    UIImage *editImage = [editImageSelected imageWithColor:color];
    
    catItem.image = [catImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    catItem.selectedImage = catImageSelected;
    
    dailyItem.image = [dailyImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    dailyItem.selectedImage = dailyImageSelected;
    
    editItem.image = [editImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    editItem.selectedImage = editImageSelected;
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
