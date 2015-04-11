//
//  AddTravelViewController.m
//  myTravelExpenses
//
//  Created by Stéphanie Meusling on 11.04.15.
//  Copyright (c) 2015 smeusling. All rights reserved.
//

#import "AddTravelViewController.h"
#import "TravelTableViewCell.h"
#import "Theme.h"

@interface AddTravelViewController ()

@end

@implementation AddTravelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavBar];
    [self setupButton];
}

- (void)setupButton
{
    self.addCurrencyButton.backgroundColor = [[ThemeManager sharedTheme]buttonColor];
    [self.addCurrencyButton setTitle:@"Add Currency" forState:UIControlStateNormal];
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
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TravelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TravelTableViewCell" forIndexPath:indexPath];
    return cell;
    
    
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
    
}



- (IBAction)addCurrencyButtonClicked:(id)sender
{
}

- (IBAction)addPhotoButtonClicked:(id)sender
{
}
@end
