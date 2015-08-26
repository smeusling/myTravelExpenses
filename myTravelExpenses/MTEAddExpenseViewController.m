//
//  MTEAddExpenseViewController.m
//  myTravelExpenses
//
//  Created by Stéphanie Meusling on 13.06.15.
//  Copyright (c) 2015 smeusling. All rights reserved.
//

#import "MTEAddExpenseViewController.h"
#import "IQDropDownTextField.h"
#import "MTEModel.h"
#import "MTETravel.h"
#import "MTEExpense.h"
#import "CZPickerView.h"
#import "MTECategories.h"
#import "MTECategory.h"
#import "MTECurrencyTableViewController.h"
#import "MTECurrencies.h"
#import "MTEExchangeRate.h"
#import "TSCurrencyTextField.h"
#import "MTECurrencyTextField.h"

@interface MTEAddExpenseViewController () <CZPickerViewDataSource, CZPickerViewDelegate, MTECurrencyPickerDelegate>

@property (nonatomic, strong) NSDate *expenseDate;
@property (nonatomic, strong) NSString *currencyCode;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) MTECategory *selectedCategory;

@property (nonatomic, strong) NSDateFormatter *formatter;
@property (strong, nonatomic) UIActivityIndicatorView *activityView;

@property (nonatomic, strong) UITextField *selectedTextField;

@property (nonatomic, strong) NSDecimalNumber *amount;

@end

@implementation MTEAddExpenseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.formatter = [[NSDateFormatter alloc] init];
    [self.formatter setDateFormat:@"dd MMMM yyyy"];

    self.expenseDate = [NSDate date];

    [self setupNavBar];
    [self setupTextFields];
    [self setupDatePickers];
    
    self.categories = [[MTECategories sharedCategories] categories];
    
    [self.categoryTextField addTarget:self action:@selector(openCategoryList:)forControlEvents:UIControlEventTouchDown];
    [self.currencyTextField addTarget:self action:@selector(openCurrencyList)forControlEvents:UIControlEventTouchDown];

}

#pragma mark - Setup

- (void)setupNavBar
{
    self.title = @"Add Expense";

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(closeButtonTapped)];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonTapped)];
}

- (void)setupTextFields
{
    NSNumberFormatter *formatter = [MTECurrencies formatter:self.travel.currencyCode];
    self.amountTextField.currencyNumberFormatter = formatter;
    
    [self.amountTextField setAmount:[NSDecimalNumber zero]];
    [self.amountTextField addTarget:self action:@selector(amountDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.dateTextField.text = [self.formatter stringFromDate:self.expenseDate];
    self.currencyTextField.text = self.travel.currencyCode;
}

- (void)amountDidChange:(UITextField *)textField
{
    MTECurrencyTextField *currencyTextField = (MTECurrencyTextField *)textField;
    self.amount = [NSDecimalNumber decimalNumberWithDecimal:[currencyTextField.amount decimalValue]];
}


- (void)setupDatePickers
{
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker setDate:[NSDate date]];
    [datePicker addTarget:self action:@selector(updateDateTextField:) forControlEvents:UIControlEventValueChanged];
    [self.dateTextField setInputView:datePicker];
}

#pragma mark - CZPickerView

/* comment out this method to allow
 CZPickerView:titleForRow: to work.
 */
- (NSAttributedString *)czpickerView:(CZPickerView *)pickerView attributedTitleForRow:(NSInteger)row
{
    
    MTECategory *cat = self.categories[row];
    NSAttributedString *att = [[NSAttributedString alloc]
                               initWithString:cat.name
                               attributes:@{
                                            NSFontAttributeName:[UIFont fontWithName:@"Avenir-Light" size:18.0]
                                            }];
    return att;
}

- (NSString *)czpickerView:(CZPickerView *)pickerView titleForRow:(NSInteger)row
{
    MTECategory *cat = self.categories[row];
    return cat.name;
}

- (NSInteger)numberOfRowsInPickerView:(CZPickerView *)pickerView
{
    return self.categories.count;
}

- (void)czpickerView:(CZPickerView *)pickerView didConfirmWithItemAtRow:(NSInteger)row
{
    MTECategory *cat = self.categories[row];
    self.selectedCategory = cat;
    self.categoryTextField.text =cat.name;
}

#pragma mark - DatePicker

-(void)updateDateTextField:(id)sender
{
    UIDatePicker *datePicker = (UIDatePicker*)self.dateTextField.inputView;

    self.dateTextField.text = [self.formatter stringFromDate:datePicker.date];
    self.expenseDate = datePicker.date;
}

#pragma mark - Nav Bar Button

- (void)closeButtonTapped
{
    id<MTEAddExpenseDelegate> delegate = self.addExpenseDelegate;
    if (delegate) {
        [delegate addExpenseCancelled];
    }
}

- (void)saveButtonTapped
{
    [self addExpense];
}

#pragma mark - TextField Delegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.selectedTextField = textField;
    if(textField.tag == 1 || textField.tag == 2){
        return NO;
    }
    return YES;  // Hide both keyboard and blinking cursor.
}


#pragma mark - MTECurrencyPickerDelegate

- (void)selectedCurrencyWithCode:(NSString *)code
{
    self.currencyCode = code;
    self.currencyTextField.text = code;//[[MTECurrencies sharedInstance] currencyFullNameForCode:self.currencyCode];
    
    // Need to look for an exchange rate?
    if ([self.currencyCode isEqualToString:self.travel.currencyCode] == NO) {
        // Is this exchange rate already set in the database?
        for (MTEExchangeRate *rate in self.travel.rates) {
            if ([rate.travelCurrencyCode isEqualToString:self.travel.currencyCode]
                && [rate.currencyCode isEqualToString:self.currencyCode]
                && (rate.rate != nil)) {
                // This exchange rate is already there and valid
                return;
            }
        }
        
        [self showActivityView];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [MTEExchangeRate getExchangeRates:^(NSDictionary *rates) {
                NSDecimalNumber *usdToEventCurrencyRate;
                if ([self.travel.currencyCode isEqualToString:@"USD"] == NO) {
                    usdToEventCurrencyRate = [rates valueForKey:self.travel.currencyCode];
                } else {
                    usdToEventCurrencyRate = [NSDecimalNumber one];
                }
                NSDecimalNumber *usdToPaymentCurrencyRate;
                if ([self.currencyCode isEqualToString:@"USD"] == NO) {
                    usdToPaymentCurrencyRate = [rates valueForKey:self.currencyCode];
                } else {
                    usdToPaymentCurrencyRate = [NSDecimalNumber one];
                }
                
                if (usdToEventCurrencyRate && usdToPaymentCurrencyRate) {
                    [[MTEModel sharedInstance] addExchangeRate:self.travel currencyCode:self.currencyCode rate:[usdToEventCurrencyRate decimalNumberByDividingBy:usdToPaymentCurrencyRate]];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self hideActivityView];
                    });
                } else {
                    // Ask user for the rate as it could not be found automatically
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self hideActivityView];
                        [self promptForRate:NO];
                    });
                }
            }];
        });
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Other method

- (void)addExpense
{
    
    MTEExpense *newExpense = [[MTEModel sharedInstance]createExpenseWithName:self.descriptionTextField.text date:self.expenseDate amount:self.amount travel:self.travel currencyCode:self.currencyCode categoryId:self.selectedCategory.categoryId];

    id<MTEAddExpenseDelegate> delegate = self.addExpenseDelegate;
    if (delegate) {
        [delegate addExpense:newExpense];
    }
}

- (IBAction)openCategoryList:(id)sender
{
    [self.selectedTextField resignFirstResponder];
    CZPickerView *picker = [[CZPickerView alloc] initWithHeaderTitle:@"Fruits" cancelButtonTitle:@"Cancel" confirmButtonTitle:@"Confirm"];
    picker.delegate = self;
    picker.dataSource = self;
    picker.needFooterView = NO;
    [picker show];
}

- (void)openCurrencyList
{
    [self.selectedTextField resignFirstResponder];
    MTECurrencyTableViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MTECurrencyTableViewController"];
    viewController.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)showActivityView
{
    if (self.activityView == nil) {
        self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.activityView.color = [UIColor blackColor];
        self.activityView.center = CGPointMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0);
        [self.view addSubview:self.activityView];
        [self.activityView startAnimating];
    }
}

- (void)hideActivityView
{
    if (self.activityView != nil) {
        [self.activityView stopAnimating];
        [self.activityView removeFromSuperview];
        self.activityView = nil;
    }
}

- (void)promptForRate:(BOOL)askingAgain
{
    NSString *nameForEventCurrency = [[MTECurrencies sharedInstance] currencySymbolForCode:self.travel.currencyCode];
    NSString *nameForPaymentCurrency = [[MTECurrencies sharedInstance] currencySymbolForCode:self.currencyCode];
    NSNumberFormatter *formatter = [MTECurrencies formatter:self.currencyCode];
    NSString *title;
    if (askingAgain) {
        title = NSLocalizedString(@"InvalidExchangeRate", nil);
    } else {
        NSString *format = NSLocalizedString(@"ExchangeRateDialogTitleFormat", nil);
        title = [NSString stringWithFormat:format, nameForPaymentCurrency, nameForEventCurrency];
    }
    NSString *format = NSLocalizedString(@"ExchangeRateDialogMessageFormat", nil);
    NSString *message = [NSString stringWithFormat:format, nameForEventCurrency, [formatter stringFromNumber:[NSNumber numberWithInt:1]], nameForPaymentCurrency];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alert show];
    UITextField *textField = [alert textFieldAtIndex:0];
    textField.keyboardType = UIKeyboardTypeDecimalPad;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // Handle "OK"
    UITextField *textField = [alertView textFieldAtIndex:0];
    NSString *rateString = textField.text;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.locale = [NSLocale currentLocale];
    NSDecimalNumber *rate = [NSDecimalNumber decimalNumberWithDecimal:[[formatter numberFromString:rateString] decimalValue]];
    if ([rate isEqualToNumber:[NSDecimalNumber notANumber]] || [rate isEqualToNumber:[NSDecimalNumber zero]]) {
        // Ask again, rate is not valid
        [self promptForRate:YES];
    } else {
        [[MTEModel sharedInstance] addExchangeRate:self.travel currencyCode:self.currencyCode rate:rate];
    }
}

@end

