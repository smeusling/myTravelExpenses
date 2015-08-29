//
//  MTEAddExpenseViewController.h
//  myTravelExpenses
//
//  Created by Stéphanie Meusling on 13.06.15.
//  Copyright (c) 2015 smeusling. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MTEExpense, MTETravel, IQDropDownTextField, TSCurrencyTextField;

@protocol MTEAddExpenseDelegate;

@interface MTEAddExpenseViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) MTETravel *travel;

@property (nonatomic, weak) id<MTEAddExpenseDelegate> addExpenseDelegate;
@property (strong, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UITextField *dateTextField;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (strong, nonatomic) IBOutlet TSCurrencyTextField *amountTextField;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (strong, nonatomic) IBOutlet UITextField *categoryTextField;

- (IBAction)changeCurrencyButtonClicked:(id)sender;


@end

@protocol MTEAddExpenseDelegate <NSObject>

- (void)addExpenseCancelled;
- (void)addExpense:(MTEExpense *)expense;

@end