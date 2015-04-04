//
//  TravelListViewController.h
//  myTravelExpenses
//
//  Created by Stéphanie Meusling on 04.04.15.
//  Copyright (c) 2015 smeusling. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TravelListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
