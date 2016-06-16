//
//  MTEExportViewController.h
//  myTravelExpenses
//
//  Created by Stéphanie Meusling on 01.06.16.
//  Copyright © 2016 smeusling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@class MTETravel;
@interface MTEExportViewController : UIViewController <MFMailComposeViewControllerDelegate>

@property(nonatomic, strong)MTETravel *travel;

@property (weak, nonatomic) IBOutlet UIButton *exportButton;
- (IBAction)exportButtonClicked:(id)sender;
@end
