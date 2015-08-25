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

@property (nonatomic, weak) id<MTEAddExpenseDelegate> addExpenseDelegate;
@property (strong, nonatomic) IBOutlet UITextField *descriptionTextField;
@property (strong, nonatomic) IBOutlet UITextField *dateTextField;
@property (strong, nonatomic) IBOutlet TSCurrencyTextField *amountTextField;
@property (strong, nonatomic) IBOutlet UITextField *categoryTextField;
@property (weak, nonatomic) IBOutlet UITextField *currencyTextField;

- (IBAction)openCategoryList:(id)sender;

@property (weak, nonatomic) MTETravel *travel;

@end

@protocol MTEAddExpenseDelegate <NSObject>

- (void)addExpenseCancelled;
- (void)addExpense:(MTEExpense *)expense;

@end