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
#import "MTEExpenseListTableViewController.h"
#import "MTECurrencies.h"
#import <QuartzCore/QuartzCore.h>

@interface MTETravelListViewController () <MTEAddTravelDelegate>

@property (nonatomic, strong) NSMutableArray *travels;
@property (nonatomic, strong) MTETravel *selectedTravel;
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
    
    self.travels = fetchedObjects.mutableCopy;

    self.tableView.allowsMultipleSelectionDuringEditing = NO;

    [self setupBackgroundView];
    //self.profile = [MTEConfigUtil profile];
    [self setupNavBar];
}

- (void)setupNavBar
{
    self.title = @"Travel Expenses";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menu-button"] style:UIBarButtonItemStylePlain target:self action:@selector(menuButtonTapped)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"add-button"] style:UIBarButtonItemStylePlain target:self action:@selector(addButtonTapped)];
}

- (void)setupBackgroundView
{
    if(!self.travels || [self.travels count]<1){
        self.tableView.backgroundView = [self setupEmptyView];
    }else{
        self.tableView.backgroundView = nil;
    }
}

- (UIView *)setupEmptyView
{
    
    MTETravelListEmptyView *view = [[[NSBundle mainBundle]
                     loadNibNamed:@"MTETravelListEmptyView"
                     owner:self options:nil]
                    firstObject];
    view.placeholderLabel.text = @"No Travel Yet";
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
    cell.travelImageView.clipsToBounds = YES;
    if(travel.image){
        cell.travelImageView.image = [UIImage imageWithData:travel.image];
    }else{
        cell.travelImageView.image = [UIImage imageNamed:@"japon"];
    }
    
    NSNumberFormatter *formatter = [MTECurrencies formatter:travel.currencyCode];

    cell.travelCurrency.text = [formatter stringFromNumber:[travel totalAmount]];
//    cell.travelUserCurrency.text = self.profile.currency.name;
    
    return cell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}


// Override to support conditional editing of the table view.
// This only needs to be implemented if you are going to be returning NO
// for some items. By default, all items are editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        MTETravel *travel = self.travels[indexPath.row];
        [[[MTEModel sharedInstance]managedObjectContext] deleteObject:travel];
        [[[MTEModel sharedInstance]managedObjectContext] save:nil];
        [self.travels removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [self setupBackgroundView];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedTravel = self.travels[indexPath.row];
}

#pragma mark - MTEAddTravelDelegate
- (void)addTravelCancelled
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addTravel:(MTETravel *)travel
{
    [self.travels addObject:travel];
    [self.tableView reloadData];
    [self setupBackgroundView];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Segue 

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"travelExpenseList"])
    {
        NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];

        // Get reference to the destination view controller
        UITabBarController *tabBarController = [segue destinationViewController];



        for (UIViewController *v in tabBarController.viewControllers)
        {
            if ([v isKindOfClass:[MTEExpenseListTableViewController class]]){
                MTEExpenseListTableViewController *travelViewController = (MTEExpenseListTableViewController *)v;
                travelViewController.travel = self.travels[selectedRowIndex.row];
            }

        }
        tabBarController.selectedIndex = 1;
    }
}



#pragma mark

-(NSString *)convertDatesToStringWithFirstDate:(NSDate *)firstDate secondDate:(NSDate *)secondDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd MMM yyyy"];
    
   return [NSString stringWithFormat:@"%@ - %@",[formatter stringFromDate:firstDate], [formatter stringFromDate:secondDate] ];
}

#pragma mark - Nav Bar button clicked

- (void)addButtonTapped
{
    MTEAddTravelViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MTEAddTravelViewController"];
    viewController.addTravelDelegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)menuButtonTapped
{
    [self takeScreenShot];
}

-(void)takeScreenShot
{
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        UIGraphicsBeginImageContextWithOptions(window.bounds.size, NO, [UIScreen mainScreen].scale);
    else
        UIGraphicsBeginImageContext(window.bounds.size);
    
    [window.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.imageView.image = image;
}

@end
