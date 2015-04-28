//
//  TravelListViewController.m
//  myTravelExpenses
//
//  Created by Stéphanie Meusling on 04.04.15.
//  Copyright (c) 2015 smeusling. All rights reserved.
//

#import "MTETravelListViewController.h"
#import <CoreData/CoreData.h>
#import "MTETravelTableViewCell.h"
#import "MTEConfigUtil.h"
#import "MTETravel.h"
//#import "MTEProfile.h"
#import "MTETravelListEmptyView.h"
//#import "MTECurrency.h"
#import "MTEModel.h"
#import "MTEAddTravelViewController.h"

@interface MTETravelListViewController ()

@property (nonatomic, strong) NSArray *travels;
//@property (nonatomic, strong) MTEProfile *profile;

@end

@implementation MTETravelListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Test listing all FailedBankInfos from the store
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Travel"
                                              inManagedObjectContext:[[MTEModel sharedInstance]managedObjectContext]];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSArray *fetchedObjects = [[[MTEModel sharedInstance]managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    self.travels = fetchedObjects;
//    if(!self.travels || [self.travels count]>1){
//        self.tableView.backgroundView = [self setupEmptyView];
//    }else{
//         self.tableView.backgroundView = nil;
//    }
    //self.profile = [MTEConfigUtil profile];
    [self setupNavBar];
}

- (void)setupNavBar
{
    self.title = @"Travel Expenses";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menu-button"] style:UIBarButtonItemStylePlain target:self action:@selector(menuButtonTapped)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"add-button"] style:UIBarButtonItemStylePlain target:self action:@selector(addButtonTapped)];
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
//    cell.travelDates.text = [self convertDatesToStringWithFirstDate:travel.startDate secondDate:travel.endDate];
//    //cell.travelImageView.image = travel.image;
//    cell.travelImageView.image = [UIImage imageNamed:@"japon"];
//    cell.travelCurrency.text = [travel primaryCurrency].name;
//    cell.travelUserCurrency.text = self.profile.currency.name;
    
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
    MTEAddTravelViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MTEAddTravelViewController"];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)menuButtonTapped
{
    
}


@end
