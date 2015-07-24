//
//  TestViewController.m
//  myTravelExpenses
//
//  Created by Stéphanie Meusling on 28.04.15.
//  Copyright (c) 2015 smeusling. All rights reserved.
//

#import "MTEAddTravelViewController.h"
#import "MTEModel.h"

@interface MTEAddTravelViewController ()

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) NSString *currencyCode;

@property (nonatomic, strong) NSDateFormatter *formatter;

@property (nonatomic, strong)UIImagePickerController *imagePickerController;
@property (nonatomic, strong)UIImage *travelImage;

@end

@implementation MTEAddTravelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.formatter = [[NSDateFormatter alloc] init];
    [self.formatter setDateFormat:@"dd MMMM yyyy"];
    
    [self setupNavBar];
    [self setupTextFields];
    [self setupDatePickers];

}

#pragma mark - Setup

- (void)setupNavBar
{
    self.title = @"Add Travel";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(closeButtonTapped)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonTapped)];
}

- (void)setupTextFields
{
    self.startDateTextField.text = [self.formatter stringFromDate:[NSDate date]];
    self.endDateTextField.text = [self.formatter stringFromDate:[NSDate date]];
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
    //[self.addPhotoButton setImage:image forState:UIControlStateNormal];

    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
