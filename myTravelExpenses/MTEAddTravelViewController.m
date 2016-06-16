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
#import "MTETravelCurrenciesTableViewController.h"

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

@property BOOL animated;

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
        if(self.travel.image){
            self.travelImage = [UIImage imageWithData:self.travel.image];
            self.buttonImageView.image = self.travelImage;
        }else{
            self.buttonImageView.backgroundColor = [[MTEThemeManager sharedTheme]buttonColor];
        }
        if(self.travel.profileCurrencyRate){
            self.profileCurrencyRate = self.travel.profileCurrencyRate;
            self.exchangeRateLabel.hidden = NO;
            self.mainCurrencyRateLabel.hidden = NO;
            self.profileCurrencyRateLabel.hidden = NO;
            self.mainToProfileRateTextField.hidden = NO;
        }else{
            self.exchangeRateLabel.hidden = YES;
            self.mainCurrencyRateLabel.hidden = YES;
            self.profileCurrencyRateLabel.hidden = YES;
            self.mainToProfileRateTextField.hidden = YES;
        }
        
        if([self.travel.rates count]>0){
            self.manageOtherCurrencyButton.hidden = NO;
        }else{
            self.manageOtherCurrencyButton.hidden = YES;
        }
        
        self.currencyCodeTextField.userInteractionEnabled = NO;
        [self.currencyCodeTextField setTextColor:[UIColor grayColor]];
        
    }else{
        self.isNewTravel = YES;
        self.startDate = [NSDate date];
        self.endDate = [NSDate date];
        self.currencyCode = self.profileCurrencyCode;
        self.buttonImageView.backgroundColor = [[MTEThemeManager sharedTheme]buttonColor];
        self.exchangeRateLabel.hidden = YES;
        self.mainCurrencyRateLabel.hidden = YES;
        self.profileCurrencyRateLabel.hidden = YES;
        self.mainToProfileRateTextField.hidden = YES;
        self.manageOtherCurrencyButton.hidden = YES;
        [self.currencyCodeTextField addTarget:self action:@selector(openCurrencyList)forControlEvents:UIControlEventTouchDown];
        [self.currencyCodeTextField setTextColor:[UIColor blackColor]];
    }
    
    [self.buttonImageView setClipsToBounds:YES];
    self.buttonImageView.layer.cornerRadius = self.buttonImageView.frame.size.width / 2;
    
    [self setupNavBar];
    [self setupTextFields];
    [self setupDatePickers];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

#pragma mark - Setup

- (void)setupNavBar
{
    if(self.isNewTravel){
        self.navigationItem.title = NSLocalizedString(@"AddTravel", nil);
    }else{
        self.navigationItem.title = NSLocalizedString(@"EditTravel", nil);
    }
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Close", nil) style:UIBarButtonItemStylePlain target:self action:@selector(closeButtonTapped)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Save", nil) style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonTapped)];
}

- (void)setupTextFields
{
    self.exchangeRateLabel.text = NSLocalizedString(@"ExchangeRateTitle", nil).uppercaseString;
    self.mainCurrencyRateLabel.text = [NSString stringWithFormat:@"1 %@ = ",[[MTECurrencies sharedInstance] currencySymbolForCode:self.travel.currencyCode]];
    self.profileCurrencyRateLabel.text = [[MTECurrencies sharedInstance] currencySymbolForCode:[MTEConfigUtil profileCurrencyCode]];
    
    [self.mainToProfileRateTextField addTarget:self action:@selector(amountDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.mainToProfileRateTextField.text = [NSString stringWithFormat:@"%@",self.travel.profileCurrencyRate];
    [self.manageOtherCurrencyButton setTitle:NSLocalizedString(@"ManageOtherCurrency", nil).uppercaseString forState:UIControlStateNormal] ;
    self.manageOtherCurrencyButton.backgroundColor = [[MTEThemeManager sharedTheme]buttonColor];
    self.manageOtherCurrencyButton.layer.cornerRadius = 5;
    
    
    self.startDateLabel.text = NSLocalizedString(@"StartDate", nil).uppercaseString;
    self.endDateLabel.text = NSLocalizedString(@"EndDate", nil).uppercaseString;
    self.currencyLabel.text = NSLocalizedString(@"MainCurrency", nil).uppercaseString;
    
    self.nameTextField.placeholder = NSLocalizedString(@"EnterName", nil);
    self.currencyCodeTextField.text = [[MTECurrencies sharedInstance] currencyFullNameForCode:self.currencyCode];
    self.startDateTextField.text = [self.formatter stringFromDate:self.startDate];
    self.endDateTextField.text = [self.formatter stringFromDate:self.endDate];
}

- (void)setupDatePickers
{
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolBar.barStyle = UIBarStyleDefault;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneTouched:)];
    
    doneButton.tintColor = [UIColor darkGrayColor];
    
    [toolBar setItems:[NSArray arrayWithObjects:doneButton, nil]];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker setDate:self.startDate];
    [datePicker addTarget:self action:@selector(updateStartDateTextField:) forControlEvents:UIControlEventValueChanged];
    [self.startDateTextField setInputView:datePicker];
    self.startDateTextField.inputAccessoryView = toolBar;
    
    UIDatePicker *endDatePicker = [[UIDatePicker alloc]init];
    endDatePicker.datePickerMode = UIDatePickerModeDate;
    [endDatePicker setDate:self.endDate];
    [endDatePicker addTarget:self action:@selector(updateEndDateTextField:) forControlEvents:UIControlEventValueChanged];
    [self.endDateTextField setInputView:endDatePicker];
    self.endDateTextField.inputAccessoryView = toolBar;
    
    self.mainToProfileRateTextField.inputAccessoryView = toolBar;
}

- (void)doneTouched:(UIBarButtonItem *)sender
{
    [self.startDateTextField resignFirstResponder];
    [self.endDateTextField resignFirstResponder];
    [self.mainToProfileRateTextField resignFirstResponder];

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
    if(self.isNewTravel){
        [self addTravel];
    }else{
        //edit
        NSData *imageData;
        
        if(self.travelImage){
            
            imageData = UIImageJPEGRepresentation(self.travelImage, 1.0);
        }
        
        self.travel = [[MTEModel sharedInstance]updateTravel:self.travel name:self.nameTextField.text startDate:self.startDate endDate:self.endDate image:imageData currencyCode:self.currencyCode profileCurrencyRate:self.profileCurrencyRate];
        
        id<MTEAddTravelDelegate> delegate = self.addTravelDelegate;
        if (delegate) {
            [delegate editTravel:self.travel];
        }
    }
    
}

#pragma mark - Other method

- (void)addTravel
{

    NSData *imageData;

    if(self.travelImage){

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

- (IBAction)manageOtherCurrencyButtonClicked:(id)sender
{
    MTETravelCurrenciesTableViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MTETravelCurrenciesTableViewController"];
    viewController.travel = self.travel;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    [self presentViewController:navigationController animated:YES completion:nil];
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

- (void)amountDidChange:(UITextField *)textField
{
    self.profileCurrencyRate = [NSDecimalNumber decimalNumberWithString:textField.text];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}


#pragma mark - MTECurrencyPickerDelegate

- (void)selectedCurrencyWithCode:(NSString *)code
{
    self.currencyCode = code;
    self.currencyCodeTextField.text = [[MTECurrencies sharedInstance] currencyFullNameForCode:self.currencyCode];
    
    // Need to look for an exchange rate?
    if ([self.currencyCode isEqualToString:self.profileCurrencyCode] == NO) {
        [self showActivityView];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [MTEExchangeRate getExchangeRatesForCurrency:self.profileCurrencyCode toCurrency:self.currencyCode withCompletionHandler:^(float rate) {
                if (rate > 0) {
                    self.profileCurrencyRate = [[NSDecimalNumber alloc] initWithFloat:rate];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self hideActivityView];
                        self.mainCurrencyRateLabel.hidden = NO;
                        self.profileCurrencyRateLabel.hidden = NO;
                        self.mainToProfileRateTextField.hidden = NO;
                        self.exchangeRateLabel.hidden = NO;
                        self.mainCurrencyRateLabel.text = [NSString stringWithFormat:@"1 %@ = ",[[MTECurrencies sharedInstance] currencySymbolForCode:code]];
                        self.profileCurrencyRateLabel.text = [[MTECurrencies sharedInstance] currencySymbolForCode:[MTEConfigUtil profileCurrencyCode]];
                        self.mainToProfileRateTextField.text = [NSString stringWithFormat:@"%@",self.profileCurrencyRate];
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
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancelCurrencyPicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Keyboard
-(void)keyboardWillShow {
    // Animate the current view out of the way
    if ([self.mainToProfileRateTextField isFirstResponder]) {
        CGRect viewFrame = self.view.frame;
        [UIView animateWithDuration:0.3f animations:^ {
            self.view.frame = CGRectMake(viewFrame.origin.x, viewFrame.origin.y-160, viewFrame.size.width, viewFrame.size.height);
        }];
        self.animated = YES;
    }
}

-(void)keyboardWillHide {
    // Animate the current view back to its original position
    if (self.animated) {
        CGRect viewFrame = self.view.frame;
        [UIView animateWithDuration:0.3f animations:^ {
            self.view.frame = CGRectMake(viewFrame.origin.x, viewFrame.origin.y+160, viewFrame.size.width, viewFrame.size.height);
        }];
        self.animated = NO;
    }
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
    alert.tag = 0;
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alert show];
    UITextField *textField = [alert textFieldAtIndex:0];
    textField.keyboardType = UIKeyboardTypeDecimalPad;
}

- (void)promptForInfo
{
    NSString *title = NSLocalizedString(@"ExchangeRateWarningTitle", nil);
    NSString *message =  NSLocalizedString(@"ExchangeRateWarningMessage", nil);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    alert.tag = 1;
    [alert setAlertViewStyle:UIAlertViewStyleDefault];
    [alert show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // Handle "OK"
    if(alertView.tag == 0){
        UITextField *textField = [alertView textFieldAtIndex:0];
        NSString *rateString = textField.text;
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.locale = [NSLocale currentLocale];
        NSDecimalNumber *rate = [NSDecimalNumber decimalNumberWithDecimal:[[formatter numberFromString:rateString] decimalValue]];
        self.profileCurrencyRate = rate;
        if ([rate isEqualToNumber:[NSDecimalNumber notANumber]] || [rate isEqualToNumber:[NSDecimalNumber zero]]) {
            // Ask again, rate is not valid
            [self promptForInfo];
        } else {
            self.mainCurrencyRateLabel.hidden = NO;
            self.profileCurrencyRateLabel.hidden = NO;
            self.mainToProfileRateTextField.hidden = NO;
            self.exchangeRateLabel.hidden = NO;
            self.mainCurrencyRateLabel.text = [NSString stringWithFormat:@"1 %@ = ",[[MTECurrencies sharedInstance] currencySymbolForCode:self.currencyCode]];
            self.profileCurrencyRateLabel.text = [[MTECurrencies sharedInstance] currencySymbolForCode:[MTEConfigUtil profileCurrencyCode]];
            self.mainToProfileRateTextField.text = [NSString stringWithFormat:@"%@",self.profileCurrencyRate];
        }
    }else{
        
    }
}



@end
