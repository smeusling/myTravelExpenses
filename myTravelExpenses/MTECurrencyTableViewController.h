//
//  MTECurrencyTableViewController.h
//  myTravelExpenses
//
//  Created by Stéphanie Meusling on 19.08.15.
//  Copyright (c) 2015 smeusling. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MTECurrencyPickerDelegate <NSObject>

- (void)selectedCurrencyWithCode:(NSString *)code;

@end

@interface MTECurrencyTableViewController : UITableViewController

@property (nonatomic, strong) id<MTECurrencyPickerDelegate> delegate;

@end
