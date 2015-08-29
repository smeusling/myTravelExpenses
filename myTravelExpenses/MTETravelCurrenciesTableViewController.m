//
//  MTETravelCurrenciesTableViewController.m
//  myTravelExpenses
//
//  Created by Stéphanie Meusling on 28.08.15.
//  Copyright (c) 2015 smeusling. All rights reserved.
//

#import "MTETravelCurrenciesTableViewController.h"
#import "MTETravel.h"
#import "MTEExchangeRate.h"
#import "MTEExchangeRateTransient.h"
#import "MTECurrencies.h"
#import "MTETextField.h"
#import "MTEModel.h"

@interface MTETravelCurrenciesTableViewController ()

@property (nonatomic, strong) NSMutableArray *rates;
@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, strong) UITextField *selectedTextField;

@end

@implementation MTETravelCurrenciesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // This will remove extra separators from tableview
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    self.rates = [[NSMutableArray alloc]initWithArray:[self.travel.rates allObjects]];
    
    [self setupNavBar];
    [self setupToolBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.rates count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditCurrencyCell" forIndexPath:indexPath];
    MTEExchangeRateTransient *rate = [self.rates objectAtIndex:indexPath.row];
    
    UILabel *label = (UILabel *)[cell viewWithTag:1];
    NSNumberFormatter *formatter = [MTECurrencies formatter:rate.currencyCode];
    label.text = [NSString stringWithFormat:NSLocalizedString(@"ExchangeRateFormat", nil), [formatter stringFromNumber:[NSDecimalNumber one]]];
    
    MTETextField *textField = (MTETextField *)[cell viewWithTag:2];
    textField.integerUserData = indexPath.row;
    UIColor *defaultTintColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    textField.tintColor = defaultTintColor;
    NSNumberFormatter *eventFormatter = [MTECurrencies formatterNoCurrency10Digits:self.travel.currencyCode];
    textField.text = [eventFormatter stringFromNumber:rate.rate];
    textField.inputAccessoryView = self.toolBar;
    [textField addTarget:self action:@selector(amountDidChange:) forControlEvents:UIControlEventEditingChanged];
    [textField addTarget:self action:@selector(editTextField:) forControlEvents:UIControlEventEditingDidBegin];
    
    UILabel *currencyLabel = (UILabel *)[cell viewWithTag:3];
    currencyLabel.text = [[MTECurrencies sharedInstance] currencySymbolForCode:self.travel.currencyCode];
    
    return cell;
}

- (void)amountDidChange:(UITextField *)textField
{
    MTETextField *currencyTextField = (MTETextField *)textField;
    MTEExchangeRate *rate = [self.rates objectAtIndex:currencyTextField.integerUserData];
    rate.rate = [NSDecimalNumber decimalNumberWithString:textField.text];;
}

- (void)editTextField:(UITextField *)textField
{
    
    self.selectedTextField = textField;
}

- (void)doneTouched:(UIBarButtonItem *)sender
{
    [self.selectedTextField resignFirstResponder];
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

 - (void)setupNavBar
 {
 self.navigationItem.title = NSLocalizedString(@"ExchangeRateTitle", nil);

 self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Close", nil) style:UIBarButtonItemStylePlain target:self action:@selector(closeButtonTapped)];
 
 self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Save", nil) style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonTapped)];
 }

- (void)setupToolBar
{
    
    self.toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.toolBar.barStyle = UIBarStyleDefault;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneTouched:)];
    
    doneButton.tintColor = [UIColor darkGrayColor];
    
    [self.toolBar setItems:[NSArray arrayWithObjects:doneButton, nil]];
    
}

- (void)closeButtonTapped
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveButtonTapped
{
    [[[MTEModel sharedInstance]managedObjectContext] save:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
