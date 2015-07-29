//
//  MTEExpenseListTableViewController.m
//  myTravelExpenses
//
//  Created by Stéphanie Meusling on 27.06.15.
//  Copyright (c) 2015 smeusling. All rights reserved.
//

#import "MTEExpenseListTableViewController.h"
#import "MTETravelListEmptyView.h"
#import "MTETravel.h"
#import "MTEAddExpenseViewController.h"
#import "MTEExpense.h"

@interface MTEExpenseListTableViewController () <MTEAddExpenseDelegate>

@property (nonatomic, strong) NSMutableArray *expenses;

@end

@implementation MTEExpenseListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupNavBar];

    // This will remove extra separators from tableview
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    self.expenses = [[NSMutableArray alloc]initWithArray:[self.travel.expenses allObjects]];

    [self setupBackgroundView];
    
}

#pragma mark - Setup methods

- (void)setupNavBar
{
    self.tabBarController.title = self.travel.name;

    self.tabBarController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"add-button"] style:UIBarButtonItemStylePlain target:self action:@selector(addButtonTapped)];
}

- (void)setupBackgroundView
{
    if(!self.expenses || [self.expenses count]<1){
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
    return [self.expenses count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    MTEExpense *expense = self.expenses[indexPath.row];

    //Add expense to travel
    //self.travel

    cell.textLabel.text = expense.name;

    return cell;


}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


//// Override to support conditional editing of the table view.
//// This only needs to be implemented if you are going to be returning NO
//// for some items. By default, all items are editable.
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Return YES if you want the specified item to be editable.
//    return YES;
//}
//
//// Override to support editing the table view.
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        MTETravel *travel = self.travels[indexPath.row];
//        [[[MTEModel sharedInstance]managedObjectContext] deleteObject:travel];
//        [[[MTEModel sharedInstance]managedObjectContext] save:nil];
//        [self.travels removeObjectAtIndex:indexPath.row];
//        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
//        [self setupBackgroundView];
//    }
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    self.selectedTravel = self.travels[indexPath.row];
//}


#pragma mark - MTEAddExpenseDelegate

- (void)addExpenseCancelled
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addExpense:(MTEExpense *)expense
{
    [self.expenses addObject:expense];
    [self.tableView reloadData];
    [self setupBackgroundView];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Nav Bar button clicked

- (void)addButtonTapped
{
    MTEAddExpenseViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MTEAddExpenseViewController"];
    viewController.addExpenseDelegate = self;
    viewController.travel = self.travel;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];

    [self presentViewController:navigationController animated:YES completion:nil];
}


@end
