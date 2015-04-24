//
//  TravelListViewController.m
//  myTravelExpenses
//
//  Created by Stéphanie Meusling on 04.04.15.
//  Copyright (c) 2015 smeusling. All rights reserved.
//

#import "MTETravelListViewController.h"
#import "MTETravelTableViewCell.h"
#import "MTEConfigUtil.h"
#import "MTETravel.h"
#import "MTEProfile.h"
#import "MTETravelListEmptyView.h"
#import "MTEAddTravelViewController.h"
#import "MTECurrency.h"

@interface MTETravelListViewController ()

@property (nonatomic, strong) NSArray *travels;
@property (nonatomic, strong) MTEProfile *profile;

@end

@implementation MTETravelListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.travels = [MTEConfigUtil travelDataTest];
    if(!self.travels || [self.travels count]>1){
        self.tableView.backgroundView = [self setupEmptyView];
    }else{
         self.tableView.backgroundView = nil;
    }
    self.profile = [MTEConfigUtil profile];
    [self setupNavBar];
}

- (void)setupNavBar
{
    self.title = @"Travel Expenses";
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setFrame:CGRectMake(0, 0, 40, 40)];
    [addButton setImage:[UIImage imageNamed:@"add-button"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    
    UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [menuButton setFrame:CGRectMake(0, 0, 40, 40)];
    [menuButton setImage:[UIImage imageNamed:@"menu-button"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(menuButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
}

- (UIView *)setupEmptyView
{
    
    MTETravelListEmptyView *view = [[[NSBundle mainBundle]
                     loadNibNamed:@"TravelListEmptyView"
                     owner:self options:nil]
                    firstObject];
    view.placeholderLabel.text = @"No Travel Expenses Yet";
    return view;
}



#pragma mark - Table view data source / delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.travels count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MTETravelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TravelTableViewCell" forIndexPath:indexPath];
    MTETravel *travel = self.travels[indexPath.row];
    
    cell.travelName.text = travel.name;
    cell.travelDates.text = [self convertDatesToStringWithFirstDate:travel.startDate secondDate:travel.endDate];
    //cell.travelImageView.image = travel.image;
    cell.travelImageView.image = [UIImage imageNamed:@"japon"];
    cell.travelCurrency.text = [travel primaryCurrency].name;
    cell.travelUserCurrency.text = self.profile.currency.name;
    
    return cell;
    
    
}

-(NSString *)convertDatesToStringWithFirstDate:(NSDate *)firstDate secondDate:(NSDate *)secondDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd mm yyyy"];
    
   return [NSString stringWithFormat:@"%@ - %@",[formatter stringFromDate:firstDate], [formatter stringFromDate:secondDate] ];
}

#pragma mark - Nav Bar button clicked

- (void)addButtonTapped
{
    MTEAddTravelViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AddTravelViewController"];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)menuButtonTapped
{
    
}


@end
