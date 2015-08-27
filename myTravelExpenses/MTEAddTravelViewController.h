//
//  TestViewController.h
//  myTravelExpenses
//
//  Created by Stéphanie Meusling on 28.04.15.
//  Copyright (c) 2015 smeusling. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MTETravel;

@protocol MTEAddTravelDelegate;

@interface MTEAddTravelViewController : UIViewController <UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) MTETravel *travel;

@property (nonatomic, weak) id<MTEAddTravelDelegate> addTravelDelegate;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *startDateTextField;
@property (weak, nonatomic) IBOutlet UITextField *endDateTextField;
@property (weak, nonatomic) IBOutlet UITextField *currencyCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *addPhotoButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *buttonImageView;

- (IBAction)addPhotoButtonClicked:(id)sender;

@end

@protocol MTEAddTravelDelegate <NSObject>

- (void)addTravelCancelled;
- (void)addTravel:(MTETravel *)travel;
- (void)editTravel:(MTETravel *)travel;

@end
