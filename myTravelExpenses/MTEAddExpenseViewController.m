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

@interface MTEAddExpenseViewController () <CZPickerViewDataSource, CZPickerViewDelegate>

@property (nonatomic, strong) NSDate *expenseDate;
@property (nonatomic, strong) NSString *currencyCode;
@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) MTECategory *selectedCategory;

@property (nonatomic, strong) NSDateFormatter *formatter;

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
    self.dateTextField.text = [self.formatter stringFromDate:self.expenseDate];
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
    if(textField.tag == 1){
        return NO;
    }
    return YES;  // Hide both keyboard and blinking cursor.
}

#pragma mark - Other method

- (void)addExpense
{
    float amountFloat = [self.amountTextField.text floatValue];
    MTEExpense *newExpense = [[MTEModel sharedInstance]createExpenseWithName:self.descriptionTextField.text date:self.expenseDate amount:[NSNumber numberWithFloat:amountFloat] travel:self.travel currencyCode:nil categoryId:self.selectedCategory.categoryId];

    id<MTEAddExpenseDelegate> delegate = self.addExpenseDelegate;
    if (delegate) {
        [delegate addExpense:newExpense];
    }
}

- (IBAction)openCategoryList:(id)sender
{
    CZPickerView *picker = [[CZPickerView alloc] initWithHeaderTitle:@"Fruits" cancelButtonTitle:@"Cancel" confirmButtonTitle:@"Confirm"];
    picker.delegate = self;
    picker.dataSource = self;
    picker.needFooterView = NO;
    [picker show];
}
@end

