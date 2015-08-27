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
#import "MTEConfigUtil.h"

@interface MTETravelListViewController () <MTEAddTravelDelegate>

@property (nonatomic, strong) NSMutableArray *travels;
@property (nonatomic, strong) MTETravel *selectedTravel;
@property (nonatomic, strong) MTETravel *selectedTravelForEdition;
//@property (nonatomic, strong) MTEProfile *profile;

@end

@implementation MTETravelListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadTravelData];
    
//    for (MTETravel *travel in self.travels) {
//        [[[MTEModel sharedInstance]managedObjectContext] deleteObject:travel];
//
//    }
//    [[[MTEModel sharedInstance]managedObjectContext] save:nil];
    
    // This will remove extra separators from tableview
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];


    self.tableView.allowsMultipleSelectionDuringEditing = NO;

    [self setupBackgroundView];
    //self.profile = [MTEConfigUtil profile];
    [self setupNavBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTravelData) name:@"MTEExpenseAdded" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTravelData) name:@"MTEExpenseRemoved" object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MTEExpenseAdded" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MTEExpenseRemoved" object:nil];
}

- (void)setupNavBar
{
    self.title = NSLocalizedString(@"TravelExpense", nil);
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil
                                                                            action:nil];
    
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
    view.placeholderLabel.text = NSLocalizedString(@"EmptyTravel", nil);
    return view;
}

#pragma mark - Loading data

-(void)reloadTravelData
{
    [self loadTravelData];
    [self.tableView reloadData];
}

-(void)loadTravelData
{
    // Test listing all FailedBankInfos from the store
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Travel"
                                              inManagedObjectContext:[[MTEModel sharedInstance]managedObjectContext]];
    [fetchRequest setEntity:entity];
    NSError *error = nil;
    NSArray *fetchedObjects = [[[MTEModel sharedInstance]managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"startDate" ascending:NO];
    NSArray *orderedArray = [fetchedObjects sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    self.travels = orderedArray.mutableCopy;
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
        cell.travelImageView.image = [UIImage imageNamed:@"plane"];
    }
    
    NSNumberFormatter *formatter = [MTECurrencies formatter:travel.currencyCode];

    if([travel.currencyCode isEqualToString:[MTEConfigUtil profileCurrencyCode]]){
        cell.travelCurrency.hidden = YES;
    }else{
        cell.travelCurrency.hidden = NO;
        cell.travelCurrency.text = [NSString stringWithFormat:@"%@ =",[formatter stringFromNumber:[travel totalAmount]]];
    }
    
    
    NSNumberFormatter *profileFormatter = [MTECurrencies formatter:[MTEConfigUtil profileCurrencyCode]];
    cell.travelUserCurrency.text = [profileFormatter stringFromNumber:[travel totalAmountInProfileCurrency]];
    
//    cell.editButton.tag = indexPath.row;
//    [cell.editButton addTarget:self action:@selector(editButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}


// Override to support conditional editing of the table view.
// This only needs to be implemented if you are going to be returning NO
// for some items. By default, all items are editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:NSLocalizedString(@"Delete", nil) handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        MTETravel *travel = self.travels[indexPath.row];
        [[[MTEModel sharedInstance]managedObjectContext] deleteObject:travel];
        [[[MTEModel sharedInstance]managedObjectContext] save:nil];
        [self.travels removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [self setupBackgroundView];
    }];
    
    UITableViewRowAction *edit = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:NSLocalizedString(@"Edit", nil) handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        self.selectedTravelForEdition = self.travels[indexPath.row];
        [self addButtonTapped];
    }];
    
    return @[delete,edit];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedTravel = self.travels[indexPath.row];
}

#pragma mark - MTEAddTravelDelegate
- (void)addTravelCancelled
{
    self.selectedTravelForEdition = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addTravel:(MTETravel *)travel
{
    self.selectedTravelForEdition = nil;
    [self reloadTravelData];
    [self setupBackgroundView];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)editTravel:(MTETravel *)travel
{
    [self addTravel:travel];
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
    
    NSDateFormatter *formatterWithoutYear = [[NSDateFormatter alloc] init];
    [formatterWithoutYear setDateFormat:@"dd MMM"];
    
    NSDateComponents *firstDatecomponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:firstDate];
    
    NSDateComponents *secondDatecomponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:secondDate];
    
    if([firstDatecomponents year]==[secondDatecomponents year]){
        return [NSString stringWithFormat:@"%@ - %@",[formatterWithoutYear stringFromDate:firstDate], [formatter stringFromDate:secondDate] ];
    }else{
        return [NSString stringWithFormat:@"%@ - %@",[formatter stringFromDate:firstDate], [formatter stringFromDate:secondDate] ];
    }
   
}

#pragma mark - Nav Bar button clicked

- (void)addButtonTapped
{
    MTEAddTravelViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MTEAddTravelViewController"];
    viewController.addTravelDelegate = self;
    viewController.travel = self.selectedTravelForEdition;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)menuButtonTapped
{
    [self takeScreenShot];
}

- (IBAction)editButtonPressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    self.selectedTravelForEdition = self.travels[button.tag];
    [self addButtonTapped];
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
