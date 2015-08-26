//
//  TestViewController.m
//  myTravelExpenses
//
//  Created by Stéphanie Meusling on 28.04.15.
//  Copyright (c) 2015 smeusling. All rights reserved.
//

#import "MTEAddTravelViewController.h"
#import "MTEModel.h"
#import "MTECurrencyTableViewController.h"
#import "MTECurrencies.h"
#import "MTEExchangeRate.h"
#import "MTETravel.h"
#import "MTETheme.h"
#import "MTEConfigUtil.h"

@interface MTEAddTravelViewController () <MTECurrencyPickerDelegate>

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) NSString *currencyCode;
@property (nonatomic, strong) NSMutableArray *rates;
@property (strong, nonatomic) UIActivityIndicatorView *activityView;

@property (nonatomic, strong) NSDateFormatter *formatter;

@property (nonatomic, strong)UIImagePickerController *imagePickerController;
@property (nonatomic, strong)UIImage *travelImage;

@property (nonatomic, strong)NSDecimalNumber *profileCurrencyRate;

@property (nonatomic, strong)NSString *profileCurrencyCode;

@property BOOL isNewTravel;

@end

@implementation MTEAddTravelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.formatter = [[NSDateFormatter alloc] init];
    [self.formatter setDateFormat:@"dd MMMM yyyy"];
    
     self.profileCurrencyCode = [MTEConfigUtil profileCurrencyCode];
    
    if(self.travel){
        self.isNewTravel = NO;
        self.rates = [[NSMutableArray alloc]initWithArray:[self.travel.rates allObjects]];
        self.nameTextField.text = self.travel.name;
        self.startDate = self.travel.startDate;
        self.endDate = self.travel.endDate;
        self.currencyCode = self.travel.currencyCode;
        self.buttonImageView.image = [UIImage imageWithData:self.travel.image];
        [self.addTravelButton setTitle:@"Modifier" forState:UIControlStateNormal];
    }else{
        self.isNewTravel = YES;
        self.startDate = [NSDate date];
        self.endDate = [NSDate date];
        self.currencyCode = self.profileCurrencyCode;
        self.buttonImageView.backgroundColor = [[MTEThemeManager sharedTheme]buttonColor];
        [self.addTravelButton setTitle:@"Ajouter" forState:UIControlStateNormal];
    }
    
    [self.buttonImageView setClipsToBounds:YES];
    self.buttonImageView.layer.cornerRadius = self.buttonImageView.frame.size.width / 2;
    
    
    self.addTravelButton.backgroundColor = [[MTEThemeManager sharedTheme]buttonColor];
    [self.addTravelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    

    // This will remove extra separators from tableview
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self setupNavBar];
    [self setupTextFields];
    [self setupDatePickers];
    
    if(self.isNewTravel){
        [self.currencyCodeTextField addTarget:self action:@selector(openCurrencyList)forControlEvents:UIControlEventTouchDown];
    }else{
        self.currencyCodeTextField.userInteractionEnabled = NO;
    }
}

#pragma mark - Table view data source / delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.rates count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CurrencyRateCell" forIndexPath:indexPath];
    
    MTEExchangeRate *rate = [self.rates objectAtIndex:indexPath.row];
    
    NSNumberFormatter *formatter = [MTECurrencies formatter:rate.currencyCode];
    cell.textLabel.text = [NSString stringWithFormat:NSLocalizedString(@"ExchangeRateFormat", nil), [formatter stringFromNumber:[NSDecimalNumber one]]];
    
    NSNumberFormatter *travelFormatter = [MTECurrencies formatter10Digits:self.travel.currencyCode];
    cell.detailTextLabel.text = [travelFormatter stringFromNumber:rate.rate];
    
    return cell;
}

#pragma mark - Setup

- (void)setupNavBar
{
    self.navigationItem.title = NSLocalizedString(@"AddTravel", nil);
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Close", nil) style:UIBarButtonItemStylePlain target:self action:@selector(closeButtonTapped)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Save", nil) style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonTapped)];
}

- (void)setupTextFields
{
    self.nameTextField.placeholder = NSLocalizedString(@"EnterName", nil);
    self.currencyCodeTextField.text = [[MTECurrencies sharedInstance] currencyFullNameForCode:self.currencyCode];
    self.startDateTextField.text = [self.formatter stringFromDate:self.startDate];
    self.endDateTextField.text = [self.formatter stringFromDate:self.endDate];
}

- (void)setupDatePickers
{
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker setDate:[NSDate date]];
    [datePicker addTarget:self action:@selector(updateStartDateTextField:) forControlEvents:UIControlEventValueChanged];
    [self.startDateTextField setInputView:datePicker];
    
    UIDatePicker *endDatePicker = [[UIDatePicker alloc]init];
    endDatePicker.datePickerMode = UIDatePickerModeDate;
    [endDatePicker setDate:[NSDate date]];
    [endDatePicker addTarget:self action:@selector(updateEndDateTextField:) forControlEvents:UIControlEventValueChanged];
    [self.endDateTextField setInputView:endDatePicker];
}

#pragma mark - DatePicker

-(void)updateStartDateTextField:(id)sender
{
    UIDatePicker *startDatePicker = (UIDatePicker*)self.startDateTextField.inputView;
    
    self.startDateTextField.text = [self.formatter stringFromDate:startDatePicker.date];
    self.startDate = startDatePicker.date;
}

-(void)updateEndDateTextField:(id)sender
{
    UIDatePicker *datePicker = (UIDatePicker*)self.endDateTextField.inputView;
    
    self.endDateTextField.text = [self.formatter stringFromDate:datePicker.date];
    self.endDate = datePicker.date;
}
#pragma mark - Nav Bar Button

- (void)closeButtonTapped
{
    id<MTEAddTravelDelegate> delegate = self.addTravelDelegate;
    if (delegate) {
        [delegate addTravelCancelled];
    }
}

- (void)saveButtonTapped
{
    // Need to look for an exchange rate?
    if ([self.currencyCode isEqualToString:self.profileCurrencyCode] == NO) {
        
        [self showActivityView];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [MTEExchangeRate getExchangeRates:^(NSDictionary *rates) {
                NSDecimalNumber *usdToEventCurrencyRate;
                if ([self.profileCurrencyCode isEqualToString:@"USD"] == NO) {
                    usdToEventCurrencyRate = [rates valueForKey:self.profileCurrencyCode];
                } else {
                    usdToEventCurrencyRate = [NSDecimalNumber one];
                }
                NSDecimalNumber *usdToPaymentCurrencyRate;
                if ([self.currencyCode isEqualToString:@"USD"] == NO) {
                    usdToPaymentCurrencyRate = [rates valueForKey:self.currencyCode];
                } else {
                    usdToPaymentCurrencyRate = [NSDecimalNumber one];
                }
                
                if (usdToEventCurrencyRate && usdToPaymentCurrencyRate) {
                    self.profileCurrencyRate = [usdToEventCurrencyRate decimalNumberByDividingBy:usdToPaymentCurrencyRate];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self hideActivityView];
                        [self addTravel];
                    });
                } else {
                    // Ask user for the rate as it could not be found automatically
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self hideActivityView];
                        [self promptForRate:NO];
                    });
                }
            }];
        });
    }else{
        [self addTravel];
    }
}

#pragma mark - Other method

- (void)addTravel
{
    //    MTETravel *newTravel = [[MTETravel alloc]initWithName:self.travelNameTextField.text
    //                                          startDate:self.startDate
    //                                            endDate:self.endDate
    //                                              image:self.travelImage
    //                                         currencies:self.currencies];

    NSData *imageData;

    if(self.travelImage){
        //imageData = UIImagePNGRepresentation(self.travelImage);

        imageData = UIImageJPEGRepresentation(self.travelImage, 1.0);
    }

    MTETravel *newTravel = [[MTEModel sharedInstance]createTravelWithName:self.nameTextField.text startDate:self.startDate endDate:self.endDate image:imageData currencyCode:self.currencyCode profileCurrencyRate:self.profileCurrencyRate];

    id<MTEAddTravelDelegate> delegate = self.addTravelDelegate;
    if (delegate) {
        [delegate addTravel:newTravel];
    }
}

- (IBAction)addPhotoButtonClicked:(id)sender
{
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:nil
                                 message:nil
                                 preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction* takePhoto = [UIAlertAction
                         actionWithTitle:NSLocalizedString(@"TakePhoto", nil)
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
                             [view dismissViewControllerAnimated:YES completion:nil];

                         }];

    UIAlertAction* photoFromLibrary = [UIAlertAction
                         actionWithTitle:NSLocalizedString(@"LibraryPhoto", nil)
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                             [view dismissViewControllerAnimated:YES completion:nil];

                         }];

    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:NSLocalizedString(@"Cancel", nil)
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [view dismissViewControllerAnimated:YES completion:nil];

                             }];


    [view addAction:takePhoto];
    [view addAction:photoFromLibrary];
    [view addAction:cancel];
    [self presentViewController:view animated:YES completion:nil];

}

- (IBAction)addTravelButtonClicked:(id)sender
{
    if(self.isNewTravel){
        [self addTravel];
    }else{
        NSData *imageData;
        
        if(self.travelImage){
            
            imageData = UIImageJPEGRepresentation(self.travelImage, 1.0);
        }
        
        self.travel = [[MTEModel sharedInstance]updateTravel:self.travel name:self.nameTextField.text startDate:self.startDate endDate:self.endDate image:imageData currencyCode:self.currencyCode profileCurrencyRate:self.profileCurrencyRate];
    }
    
}

- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.sourceType = sourceType;
    imagePickerController.delegate = self;

    self.imagePickerController = imagePickerController;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.travelImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    self.buttonImageView.image = self.travelImage;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - TextField Delegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField.tag == 1){
        return NO;
    }
    return YES;  // Hide both keyboard and blinking cursor.
}


#pragma mark - MTECurrencyPickerDelegate

- (void)selectedCurrencyWithCode:(NSString *)code
{
    self.currencyCode = code;
    self.currencyCodeTextField.text = [[MTECurrencies sharedInstance] currencyFullNameForCode:self.currencyCode];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelCurrencyPicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - other methods
- (void)openCurrencyList
{
    MTECurrencyTableViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MTECurrencyTableViewController"];
    viewController.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)showActivityView
{
    if (self.activityView == nil) {
        self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.activityView.color = [UIColor blackColor];
        self.activityView.center = CGPointMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0);
        [self.view addSubview:self.activityView];
        [self.activityView startAnimating];
    }
}

- (void)hideActivityView
{
    if (self.activityView != nil) {
        [self.activityView stopAnimating];
        [self.activityView removeFromSuperview];
        self.activityView = nil;
    }
}

- (void)promptForRate:(BOOL)askingAgain
{
    NSString *nameForEventCurrency = [[MTECurrencies sharedInstance] currencySymbolForCode:self.profileCurrencyCode];
    NSString *nameForPaymentCurrency = [[MTECurrencies sharedInstance] currencySymbolForCode:self.currencyCode];
    NSNumberFormatter *formatter = [MTECurrencies formatter:self.currencyCode];
    NSString *title;
    if (askingAgain) {
        title = NSLocalizedString(@"InvalidExchangeRate", nil);
    } else {
        NSString *format = NSLocalizedString(@"ExchangeRateDialogTitleFormat", nil);
        title = [NSString stringWithFormat:format, nameForPaymentCurrency, nameForEventCurrency];
    }
    NSString *format = NSLocalizedString(@"ExchangeRateDialogMessageFormat", nil);
    NSString *message = [NSString stringWithFormat:format, nameForEventCurrency, [formatter stringFromNumber:[NSNumber numberWithInt:1]], nameForPaymentCurrency];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alert show];
    UITextField *textField = [alert textFieldAtIndex:0];
    textField.keyboardType = UIKeyboardTypeDecimalPad;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // Handle "OK"
    UITextField *textField = [alertView textFieldAtIndex:0];
    NSString *rateString = textField.text;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.locale = [NSLocale currentLocale];
    NSDecimalNumber *rate = [NSDecimalNumber decimalNumberWithDecimal:[[formatter numberFromString:rateString] decimalValue]];
    if ([rate isEqualToNumber:[NSDecimalNumber notANumber]] || [rate isEqualToNumber:[NSDecimalNumber zero]]) {
        // Ask again, rate is not valid
        [self promptForRate:YES];
    } else {
        [self addTravel];
    }
}



@end
