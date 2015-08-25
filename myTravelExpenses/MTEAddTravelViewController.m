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

@interface MTEAddTravelViewController () <MTECurrencyPickerDelegate>

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) NSString *currencyCode;
@property (nonatomic, strong) NSMutableArray *rates;

@property (nonatomic, strong) NSDateFormatter *formatter;

@property (nonatomic, strong)UIImagePickerController *imagePickerController;
@property (nonatomic, strong)UIImage *travelImage;

@property BOOL isNewTravel;

@end

@implementation MTEAddTravelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.formatter = [[NSDateFormatter alloc] init];
    [self.formatter setDateFormat:@"dd MMMM yyyy"];
    
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
        self.currencyCode = [[NSLocale currentLocale] objectForKey:NSLocaleCurrencyCode];
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
    
    [self.currencyCodeTextField addTarget:self action:@selector(openCurrencyList)forControlEvents:UIControlEventTouchDown];

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
    
    cell.textLabel.text = [[MTECurrencies sharedInstance] currencyFullNameForCode:rate.currencyCode];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",rate.rate ];
    
    return cell;
}

#pragma mark - Setup

- (void)setupNavBar
{
    self.navigationItem.title = @"Add Travel";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(closeButtonTapped)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonTapped)];
}

- (void)setupTextFields
{
    
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
    [self addTravel];
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

    MTETravel *newTravel = [[MTEModel sharedInstance]createTravelWithName:self.nameTextField.text startDate:self.startDate endDate:self.endDate image:imageData currencyCode:self.currencyCode];

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
                         actionWithTitle:@"Prendre une photo"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
                             [view dismissViewControllerAnimated:YES completion:nil];

                         }];

    UIAlertAction* photoFromLibrary = [UIAlertAction
                         actionWithTitle:@"Bibliothèque photo"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                             [view dismissViewControllerAnimated:YES completion:nil];

                         }];

    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Annuler"
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
        
        self.travel = [[MTEModel sharedInstance]updateTravel:self.travel name:self.nameTextField.text startDate:self.startDate endDate:self.endDate image:imageData currencyCode:self.currencyCode];
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

#pragma mark - other methods
- (void)openCurrencyList
{
    MTECurrencyTableViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MTECurrencyTableViewController"];
    viewController.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    [self presentViewController:navigationController animated:YES completion:nil];
}


@end
