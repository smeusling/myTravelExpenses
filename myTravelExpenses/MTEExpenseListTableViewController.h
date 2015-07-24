//
//  MTEExpenseListTableViewController.h
//  myTravelExpenses
//
//  Created by Stéphanie Meusling on 27.06.15.
//  Copyright (c) 2015 smeusling. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MTETravel;

@interface MTEExpenseListTableViewController : UITableViewController

@property(nonatomic, strong)MTETravel *travel;

@end
