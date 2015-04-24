//
//  TravelTableViewCell.h
//  myTravelExpenses
//
//  Created by Stéphanie Meusling on 04.04.15.
//  Copyright (c) 2015 smeusling. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTETravelTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *travelImageView;
@property (weak, nonatomic) IBOutlet UILabel *travelName;
@property (weak, nonatomic) IBOutlet UILabel *travelDates;
@property (weak, nonatomic) IBOutlet UILabel *travelUserCurrency;
@property (weak, nonatomic) IBOutlet UILabel *travelCurrency;

@end
