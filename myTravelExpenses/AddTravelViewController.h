//
//  AddTravelViewController.h
//  myTravelExpenses
//
//  Created by Stéphanie Meusling on 11.04.15.
//  Copyright (c) 2015 smeusling. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddTravelViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *travelNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *startDateLabel;

@property (weak, nonatomic) IBOutlet UITextField *endDatelabel;
@property (weak, nonatomic) IBOutlet UIButton *addPhotoButton;
- (IBAction)addPhotoButtonClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *currencyTableView;
@property (weak, nonatomic) IBOutlet UIButton *addCurrencyButton;
- (IBAction)addCurrencyButtonClicked:(id)sender;
@end
