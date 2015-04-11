//
//  AddTravelViewController.m
//  myTravelExpenses
//
//  Created by Stéphanie Meusling on 11.04.15.
//  Copyright (c) 2015 smeusling. All rights reserved.
//

#import "AddTravelViewController.h"
#import "CurrencyTableViewCell.h"
#import "Theme.h"
#import "Travel.h"
#import "Profile.h"
#import "ConfigUtil.h"
#import "Currency.h"

@interface AddTravelViewController ()

@property (nonatomic, strong) NSMutableArray *currencies;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) UIImage *travelImage;
@property (nonatomic, strong) Profile *profile;

@end

@implementation AddTravelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currencies = [[NSMutableArray alloc]init];
    self.profile = [ConfigUtil profile];
    
    [self.currencies addObject:self.profile.currency];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd MMMM yyyy"];
    
    self.startDateLabel.text = @"Start date".uppercaseString;
    self.startDateTextField.text = [formatter stringFromDate:[NSDate date]];
    
    self.endDateLabel.text = @"End date".uppercaseString;
    self.endDateTextField.text = [formatter stringFromDate:[NSDate date]];
    
    self.travelNameTextField.placeholder = @"Enter Name";
    
    [self setupNavBar];
    [self setupButton];
}

- (void)setupButton
{
    self.addCurrencyButton.backgroundColor = [[ThemeManager sharedTheme]buttonColor];
    [self.addCurrencyButton setTitle:@"Add Currency".uppercaseString forState:UIControlStateNormal];
    [self.addCurrencyButton setTitleColor:[[ThemeManager sharedTheme]mainTextColor] forState:UIControlStateNormal];
}

- (void)setupNavBar
{
    self.title = @"Add Travel";
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setFrame:CGRectMake(0, 0, 50, 40)];
    [closeButton setTitle:@"Close" forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton setFrame:CGRectMake(0, 0, 50, 40)];
    [saveButton setTitle:@"Save" forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
}

#pragma mark - Table view data source / delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.currencies count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CurrencyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CurrencyTableViewCell" forIndexPath:indexPath];
    Currency *currency = self.currencies[indexPath.row];
    cell.currencyLabel.text = currency.name;
    return cell;
    
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"currency".uppercaseString;
}


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

- (void)addTravel
{
    Travel *newTravel = [[Travel alloc]initWithName:self.travelNameTextField.text
                                          startDate:self.startDate
                                            endDate:self.endDate
                                              image:self.travelImage
                                         currencies:self.currencies];
    
}



- (IBAction)addCurrencyButtonClicked:(id)sender
{
}

- (IBAction)addPhotoButtonClicked:(id)sender
{
}
@end
