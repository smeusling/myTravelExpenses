//
//  TravelListViewController.m
//  myTravelExpenses
//
//  Created by Stéphanie Meusling on 04.04.15.
//  Copyright (c) 2015 smeusling. All rights reserved.
//

#import "TravelListViewController.h"
#import "TravelTableViewCell.h"
#import "ConfigUtil.h"
#import "Travel.h"
#import "Profile.h"

@interface TravelListViewController ()

@property (nonatomic, strong) NSArray *travels;
@property (nonatomic, strong) Profile *profile;

@end

@implementation TravelListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.travels = [ConfigUtil travelDataTest];
    self.profile = [ConfigUtil profile];
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
    
    TravelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TravelTableViewCell" forIndexPath:indexPath];
    Travel *travel = self.travels[indexPath.row];
    
    cell.travelName.text = travel.name;
    cell.travelDates.text = [self convertDatesToStringWithFirstDate:travel.startDate secondDate:travel.endDate];
    cell.travelImageView.image = [UIImage imageNamed:travel.image];
    cell.travelCurrency.text = travel.mainCurrency;
    cell.travelUserCurrency.text = self.profile.currency;
    
    return cell;
    
    
}

-(NSString *)convertDatesToStringWithFirstDate:(NSDate *)firstDate secondDate:(NSDate *)secondDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd mm yyyy"];
    
   return [NSString stringWithFormat:@"%@ - %@",[formatter stringFromDate:firstDate], [formatter stringFromDate:secondDate] ];
}


@end
