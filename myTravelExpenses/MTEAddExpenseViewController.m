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

@interface MTEAddExpenseViewController ()

@property (nonatomic, strong) NSDate *expenseDate;
@property (nonatomic, strong) NSString *currencyCode;

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

    self.categoryTextField.isOptionalDropDown = NO;
    [self.categoryTextField setItemList:[NSArray arrayWithObjects:@"Transport",@"Sortie",@"Logement",@"Apéro",@"Nourriture",@"Souvenir", nil]];
}

- (void)setupDatePickers
{
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker setDate:[NSDate date]];
    [datePicker addTarget:self action:@selector(updateDateTextField:) forControlEvents:UIControlEventValueChanged];
    [self.dateTextField setInputView:datePicker];
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

#pragma mark - Other method

- (void)addExpense
{
    float amountFloat = [self.amountTextField.text floatValue];
    MTEExpense *newExpense = [[MTEModel sharedInstance]createExpenseWithName:self.descriptionTextField.text date:self.expenseDate amount:[NSNumber numberWithFloat:amountFloat] travel:self.travel currencyCode:nil category:nil];

    id<MTEAddExpenseDelegate> delegate = self.addExpenseDelegate;
    if (delegate) {
        [delegate addExpense:newExpense];
    }
}

@end

