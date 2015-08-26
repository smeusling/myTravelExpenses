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
#import "MTECategories.h"
#import "MTECategory.h"
#import "MTECategoryViewController.h"
#import "MTECurrencies.h"
#import "MTEExchangeRate.h"
#import "MTEAddTravelViewController.h"
#import "MTEModel.h"
#import "MTEUtil.h"

@interface MTEExpenseListTableViewController () <MTEAddExpenseDelegate>

@property (nonatomic, strong) NSMutableArray *expenses;
@property (nonatomic, strong) MTECategories *categories;
@property (nonatomic, strong) NSMutableArray *expenseSections;
@property float travelTotalAmount;

@property (strong, nonatomic) NSMutableDictionary *sections;
@property (strong, nonatomic) NSArray *sortedDays;
@property (strong, nonatomic) NSDateFormatter *sectionDateFormatter;
@property (strong, nonatomic) NSDateFormatter *cellDateFormatter;

@property (strong, nonatomic) NSNumberFormatter *currencyFormatter;


@end

@implementation MTEExpenseListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupNavBar];

    // This will remove extra separators from tableview
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    self.expenses = [[NSMutableArray alloc]initWithArray:[self.travel.expenses allObjects]];
    
    MTECategoryViewController *categoryViewController = [self.tabBarController.viewControllers objectAtIndex:0];
    categoryViewController.travel = self.travel;
    
    MTECategoryViewController *addTravelViewController = [self.tabBarController.viewControllers objectAtIndex:2];
    addTravelViewController.travel = self.travel;

    
    self.currencyFormatter = [MTECurrencies formatter:self.travel.currencyCode];

    [self setupBackgroundView];
    
    self.categories = [MTECategories sharedCategories];
    
    self.travelTotalAmount = 0;
    
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    [self sortExpensesByDate];
    
    [self setupHeaderView];
    
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
    view.placeholderLabel.text = NSLocalizedString(@"EmptyTravelExpense", nil);
    return view;
}

#pragma mark - Table view data source / delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:section];
    NSArray *eventsOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];
    return [eventsOnThisDay count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:section];
    return [self.sectionDateFormatter stringFromDate:dateRepresentingThisDay];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExpenseCell" forIndexPath:indexPath];
    
    NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:indexPath.section];
    NSArray *expensesOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];
    MTEExpense *expense = [expensesOnThisDay objectAtIndex:indexPath.row];
    
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:1];
    nameLabel.text = expense.name;
    
    UILabel *priceLabel = (UILabel *)[cell viewWithTag:2];
    
    NSNumberFormatter *formatter = [MTECurrencies formatter:expense.currencyCode];
    priceLabel.text = [formatter stringFromNumber:expense.amount];
    //priceLabel.text = [NSString stringWithFormat:@"%.2f",[expense.amount floatValue]];
    
    UIView *categoryView = (UIView *)[cell viewWithTag:3];
    categoryView.layer.cornerRadius = 10;
    categoryView.layer.masksToBounds = YES;
    
    MTECategory *cat = [self.categories categoryById:expense.categoryId];
    categoryView.backgroundColor = cat.color;
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, [self tableView:tableView heightForHeaderInSection:section])];
    
    header.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, header.frame.size.width -20, header.frame.size.height - 20)];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont fontWithName:@"OpenSans" size:16];
    NSDate *dateRepresentingThisDay = [self.sortedDays objectAtIndex:section];
    if([MTEUtil isSameDayWithDate1:dateRepresentingThisDay date2:[NSDate date]]){
        titleLabel.text = NSLocalizedString(@"Today", nil).uppercaseString;
    }else{
        titleLabel.text = [self.sectionDateFormatter stringFromDate:dateRepresentingThisDay];
    }
    

    [header addSubview:titleLabel];
    
    UILabel *amountLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, header.frame.size.width -20, header.frame.size.height - 20)];
    amountLabel.textAlignment = NSTextAlignmentRight;
    amountLabel.textColor = [UIColor blackColor];
    amountLabel.font = [UIFont fontWithName:@"OpenSans" size:16];
    
    NSArray *expensesOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];
    amountLabel.text = [self.currencyFormatter stringFromNumber:[self totalAmount:expensesOnThisDay]];
    
    [header addSubview:amountLabel];
    
    UIView *separator = [[UIView alloc]initWithFrame:CGRectMake(0, header.frame.size.height - 1, header.frame.size.width, 1)];
    
    separator.backgroundColor = [UIColor colorWithRed:230/255.f green:230/255.f blue:230/255.f alpha:1];
    
    [header addSubview:separator];
    
    UIView *separatorTop = [[UIView alloc]initWithFrame:CGRectMake(0, 0, header.frame.size.width, 1)];
    
    separatorTop.backgroundColor = [UIColor colorWithRed:230/255.f green:230/255.f blue:230/255.f alpha:1];
    
    [header addSubview:separatorTop];


    return header;
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
        MTETravel *travel = self.expenses[indexPath.row];
        [[[MTEModel sharedInstance]managedObjectContext] deleteObject:travel];
        [[[MTEModel sharedInstance]managedObjectContext] save:nil];
        [self.expenses removeObjectAtIndex:indexPath.row];
        [self sortExpensesByDate];
        [self setupHeaderView];
        [self.tableView reloadData];
        [self setupBackgroundView];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MTEExpenseRemoved" object:self userInfo:@{@"travel":travel}];
    }
}

- (void)setupHeaderView
{
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 50)];
    
    header.backgroundColor = [UIColor colorWithRed:0/255.f green:212/255.f blue:234/255.f alpha:1];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, header.frame.size.width -20, header.frame.size.height - 20)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont fontWithName:@"OpenSans-Light" size:20];
    titleLabel.text = NSLocalizedString(@"Total", nil);
    
    [header addSubview:titleLabel];
    
    UILabel *amountLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, header.frame.size.width -20, header.frame.size.height - 20)];
    amountLabel.backgroundColor = [UIColor clearColor];
    amountLabel.textAlignment = NSTextAlignmentRight;
    amountLabel.textColor = [UIColor whiteColor];
    amountLabel.font = [UIFont fontWithName:@"OpenSans" size:20];
    amountLabel.text = [self.currencyFormatter stringFromNumber:[self.travel totalAmount]];
    [header addSubview:amountLabel];

    
    self.tableView.tableHeaderView = header;

}


#pragma mark - MTEAddExpenseDelegate

- (void)addExpenseCancelled
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addExpense:(MTEExpense *)expense
{
    [self.expenses addObject:expense];
    [self sortExpensesByDate];
    [self setupHeaderView];
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

#pragma mark - Date Calculations

- (NSDate *)dateAtBeginningOfDayForDate:(NSDate *)inputDate
{
    // Use the user's current calendar and time zone
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [calendar setTimeZone:timeZone];
    
    // Selectively convert the date components (year, month, day) of the input date
    NSDateComponents *dateComps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:inputDate];
    
    // Set the time components manually
    [dateComps setHour:0];
    [dateComps setMinute:0];
    [dateComps setSecond:0];
    
    // Convert back
    NSDate *beginningOfDay = [calendar dateFromComponents:dateComps];
    return beginningOfDay;
}

- (NSDate *)dateByAddingYears:(NSInteger)numberOfYears toDate:(NSDate *)inputDate
{
    // Use the user's current calendar
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    [dateComps setYear:numberOfYears];
    
    NSDate *newDate = [calendar dateByAddingComponents:dateComps toDate:inputDate options:0];
    return newDate;
}


- (void)sortExpensesByDate
{
    NSSortDescriptor* sortByDate = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    NSMutableArray *expenses = [self.travel.expenses allObjects].mutableCopy;
    
    [expenses sortUsingDescriptors:[NSArray arrayWithObject:sortByDate]];
    
    self.sections = [NSMutableDictionary dictionary];
    for (MTEExpense *expense in expenses)
    {
        // Reduce event start date to date components (year, month, day)
        NSDate *dateRepresentingThisDay = [self dateAtBeginningOfDayForDate:expense.date];
        
        // If we don't yet have an array to hold the events for this day, create one
        NSMutableArray *expensesOnThisDay = [self.sections objectForKey:dateRepresentingThisDay];
        if (expensesOnThisDay == nil) {
            expensesOnThisDay = [NSMutableArray array];
            
            // Use the reduced date as dictionary key to later retrieve the event list this day
            [self.sections setObject:expensesOnThisDay forKey:dateRepresentingThisDay];
        }
        
        // Add the event to the list for this day
        [expensesOnThisDay addObject:expense];
        
        self.travelTotalAmount += [expense.amount floatValue];
    }
    
    // Create a sorted list of days
    NSArray *unsortedDays = [self.sections allKeys];
    self.sortedDays = [unsortedDays sortedArrayUsingSelector:@selector(compare:)];
    NSArray* reversedArray = [[self.sortedDays reverseObjectEnumerator] allObjects];
    self.sortedDays = reversedArray.mutableCopy;
    
    self.sectionDateFormatter = [[NSDateFormatter alloc] init];
    [self.sectionDateFormatter setDateStyle:NSDateFormatterLongStyle];
    [self.sectionDateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    self.cellDateFormatter = [[NSDateFormatter alloc] init];
    [self.cellDateFormatter setDateStyle:NSDateFormatterNoStyle];
    [self.cellDateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
}

- (NSDecimalNumber *)totalAmount:(NSArray *)expenses
{
    NSDecimalNumber *total = [NSDecimalNumber zero];
    for (MTEExpense *expense in expenses) {
        NSDecimalNumber *value = expense.amount;
        if ([expense.currencyCode isEqualToString:self.travel.currencyCode] == NO) {
            for (MTEExchangeRate *rate in self.travel.rates) {
                if ([rate.travelCurrencyCode isEqualToString:self.travel.currencyCode]
                    && [rate.currencyCode isEqualToString:expense.currencyCode]
                    && (rate.rate != nil)) {
                    value = [expense.amount decimalNumberByMultiplyingBy:rate.rate];
                    break;
                }
            }
        }
        total = [total decimalNumberByAdding:value];
    }
    return total;
}

@end
