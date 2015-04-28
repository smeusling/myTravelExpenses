//
//  TestViewController.h
//  myTravelExpenses
//
//  Created by Stéphanie Meusling on 28.04.15.
//  Copyright (c) 2015 smeusling. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTEAddTravelViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (weak, nonatomic) IBOutlet UITextField *startDateTextField;

@property (weak, nonatomic) IBOutlet UITextField *endDateTextField;

@property (weak, nonatomic) IBOutlet UITextField *currencyCodeTextField;

@property (weak, nonatomic) IBOutlet UIButton *addPhotoButton;

- (IBAction)addPhotoButtonClicked:(id)sender;

@end
