//
//  TestViewController.m
//  myTravelExpenses
//
//  Created by Stéphanie Meusling on 28.04.15.
//  Copyright (c) 2015 smeusling. All rights reserved.
//

#import "MTEAddTravelViewController.h"
#import "MTEModel.h"

@interface MTEAddTravelViewController ()

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) NSString *currencyCode;

@property (nonatomic, strong) NSDateFormatter *formatter;

@end

@implementation MTEAddTravelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.formatter = [[NSDateFormatter alloc] init];
    [self.formatter setDateFormat:@"dd MMMM yyyy"];
    
    [self setupNavBar];
    [self setupTextFields];
    [self setupDatePickers];
}

#pragma mark - Setup

- (void)setupNavBar
{
    self.title = @"Add Travel";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(closeButtonTapped)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonTapped)];
}

- (void)setupTextFields
{
    self.startDateTextField.text = [self.formatter stringFromDate:[NSDate date]];
    self.endDateTextField.text = [self.formatter stringFromDate:[NSDate date]];
}

- (void)setupDatePickers
{
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker setDate:[NSDate date]];
    [datePicker addTarget:self action:@selector(updateStartDateTextField:) forControlEvents:UIControlEventValueChanged];
    [self.startDateTextField setInputView:datePicker];
    
    UIDatePicker *endDatePicker = [[UIDatePicker alloc]init];
    endDatePicker.datePickerMode = UIDatePickerModeDate;
    [endDatePicker setDate:[NSDate date]];
    [endDatePicker addTarget:self action:@selector(updateEndDateTextField:) forControlEvents:UIControlEventValueChanged];
    [self.endDateTextField setInputView:endDatePicker];
}

#pragma mark - DatePicker

-(void)updateStartDateTextField:(id)sender
{
    UIDatePicker *startDatePicker = (UIDatePicker*)self.startDateTextField.inputView;
    
    self.startDateTextField.text = [self.formatter stringFromDate:startDatePicker.date];
    self.startDate = startDatePicker.date;
}

-(void)updateEndDateTextField:(id)sender
{
    UIDatePicker *datePicker = (UIDatePicker*)self.endDateTextField.inputView;
    
    self.endDateTextField.text = [self.formatter stringFromDate:datePicker.date];
    self.endDate = datePicker.date;
}
#pragma mark - Nav Bar Button

- (void)closeButtonTapped
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveButtonTapped
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self addTravel];
    }];
}

#pragma mark - Other method

- (void)addTravel
{
    //    MTETravel *newTravel = [[MTETravel alloc]initWithName:self.travelNameTextField.text
    //                                          startDate:self.startDate
    //                                            endDate:self.endDate
    //                                              image:self.travelImage
    //                                         currencies:self.currencies];
    
    [[MTEModel sharedInstance]createTravelWithName:self.nameTextField.text startDate:self.startDate endDate:self.endDate image:nil currencyCode:self.currencyCode];
}

- (IBAction)addPhotoButtonClicked:(id)sender {
}
@end
