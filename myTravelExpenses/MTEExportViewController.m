//
//  MTEExportViewController.m
//  myTravelExpenses
//
//  Created by Stéphanie Meusling on 01.06.16.
//  Copyright © 2016 smeusling. All rights reserved.
//

#import "MTEExportViewController.h"
#import "MTETravel.h"
#import "MTEExpense.h"
#import "AFNetworking.h"

@interface MTEExportViewController ()

@property (nonatomic, strong) NSArray *expenses;

@end

@implementation MTEExportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.expenses = [[NSMutableArray alloc]initWithArray:[self.travel.expenses allObjects]];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)exportButtonClicked:(id)sender
{
    
//    @property (nonatomic, retain) NSDecimalNumber * amount;
//    @property (nonatomic, retain) NSString * currencyCode;
//    @property (nonatomic, retain) NSDate * date;
//    @property (nonatomic, retain) NSString * name;
//    @property (nonatomic, retain) NSString * uuid;
//    @property (nonatomic, retain) NSString * categoryId;
//    @property (nonatomic, retain) MTETravel *travel;
    
//    NSString *mystr = @"";
//    NSString *headers = @"Name, Date, Amount";
//    for (MTEExpense *expense in self.expenses) {
//        mystr=[NSString stringWithFormat:@"%@ \n %@,%@,%@",mystr,expense.name, expense.date, expense.amount];
//    }
//    
//    NSString *result =[NSString stringWithFormat:@"%@ \n %@",headers,mystr];
//    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *docDir = [paths objectAtIndex:0];
//    
//    NSString *filename = [docDir stringByAppendingPathComponent:[NSString stringWithFormat:@"TravEx.csv"]];
//    NSError *error = NULL;
//    BOOL written = [result writeToFile:filename atomically:YES encoding:NSUTF8StringEncoding error:&error];
//    if (!written)
//        NSLog(@"write failed, error=%@", error);
//    [self displayComposerSheet];
    
    
    // 1
    NSString *string = @"http://api.fixer.io/latest?base=CHF&symbols=USD";
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // 2
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // 3
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        // 4
        
    }];
    
    // 5
    [operation start];
}

-(void)displayComposerSheet
{
//    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
//    picker.mailComposeDelegate = self;
//    [picker setSubject:@"Check out this image!"];
//    
//    // Set up recipients
//    // NSArray *toRecipients = [NSArray arrayWithObject:@"first@example.com"];
//    // NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
//    // NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com"];
//    
//    // [picker setToRecipients:toRecipients];
//    // [picker setCcRecipients:ccRecipients];
//    // [picker setBccRecipients:bccRecipients];
//    
//    // Attach an image to the email
//    UIImage *coolImage = ...;
//    NSData *myData = UIImagePNGRepresentation(coolImage);
//    [picker addAttachmentData:myData mimeType:@"image/png" fileName:@"coolImage.png"];
//    
//    // Fill out the email body text
//    NSString *emailBody = @"My cool image is attached";
//    [picker setMessageBody:emailBody isHTML:NO];
//    [self presentModalViewController:picker animated:YES];
    
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *csvFilePath = [documentsDirectory stringByAppendingFormat:@"/TravEx.csv"];
    
    
    
    
    NSString *recipient = @"stephing@yahoo.fr";
    NSArray *recipients = [NSArray arrayWithObjects:recipient, nil];
    
    MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
    mailViewController.mailComposeDelegate = self;
    [mailViewController setSubject:@"CSV Export"];
    [mailViewController setToRecipients:recipients];
    [mailViewController setMessageBody:@"" isHTML:NO];
    mailViewController.navigationBar.tintColor = [UIColor blackColor];
    NSData *myData = [NSData dataWithContentsOfFile:csvFilePath];
    
    [mailViewController addAttachmentData:myData
                                 mimeType:@"text/csv"
                                 fileName:@"TravEx-Report.csv"];
    
    [self presentViewController:mailViewController animated:YES completion:nil];
    

}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    // Notifies users about errors associated with the interface
//    switch (result)
//    {
//        case MFMailComposeResultCancelled:
//            message.text = @"Result: canceled";
//            break;
//        case MFMailComposeResultSaved:
//            message.text = @"Result: saved";
//            break;
//        case MFMailComposeResultSent:
//            message.text = @"Result: sent";
//            break;
//        case MFMailComposeResultFailed:
//            message.text = @"Result: failed";
//            break;
//        default:
//            message.text = @"Result: not sent";
//            break;
//    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
