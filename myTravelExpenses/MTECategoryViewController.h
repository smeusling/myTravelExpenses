//
//  MTECategoryViewController.h
//  myTravelExpenses
//
//  Created by Stéphanie Meusling on 29.07.15.
//  Copyright (c) 2015 smeusling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Charts/Charts.h>

@class MTETravel;
@interface MTECategoryViewController : UIViewController <ChartViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong)MTETravel *travel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet PieChartView *pieChartView;

@end
