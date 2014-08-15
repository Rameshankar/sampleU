//
//  RewardsZoneViewController.h
//  uTu
//
//  Created by Sankar on 20/06/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface EditProfileRewardsZoneViewController : UIViewController <UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *cancelLabel;
@property (weak, nonatomic) IBOutlet UILabel *zipValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *zipLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UILabel *whyaddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *aboutMeValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *aboutMeLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoPic;
@property (weak, nonatomic) IBOutlet UILabel *firstandLastNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateofbirthLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateofbirthValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *whydateofbirthLabel;
@property (weak, nonatomic) IBOutlet UILabel *updateLabel;
@property (weak, nonatomic) IBOutlet UIView *dateofbirthAlertView;
@property (weak, nonatomic) IBOutlet UILabel *dateofbirthAlertLabel1;
@property (weak, nonatomic) IBOutlet UILabel *dateofbirthAlertLabel2;
@property (weak, nonatomic) IBOutlet UIView *myaddressAlertView;
@property (weak, nonatomic) IBOutlet UILabel *myaddressAlertLabel1;
@property (weak, nonatomic) IBOutlet UILabel *myaddressAlertLabel2;
@property (weak, nonatomic) IBOutlet UIView *emailAlertView;
@property (weak, nonatomic) IBOutlet UILabel *emailAlertLabel1;
@property (weak, nonatomic) IBOutlet UILabel *emailAlertLabel2;
@property (weak, nonatomic) IBOutlet UILabel *myEmailLabel;
@property (weak, nonatomic) IBOutlet UITextField *firstandlastnameTextField;
@property (weak, nonatomic) IBOutlet UITextField *statusTextfield;
@property (weak, nonatomic) IBOutlet UITextField *emailTextfield;
@property (weak, nonatomic) IBOutlet UITextField *dateofbirthValueTextField;
@property (weak, nonatomic) IBOutlet UITextField *aboutmeValueTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressValueTextField;
@property (weak, nonatomic) IBOutlet UITextField *cityValueTextField;
@property (weak, nonatomic) IBOutlet UITextField *stateValueTextField;
@property (weak, nonatomic) IBOutlet UITextField *zipValueTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIView *datePickerView;

@property (nonatomic, strong) MBProgressHUD *mbHUD;
@property (nonatomic, strong) UIPopoverController *cameraPopoverController;

- (IBAction)emailButton:(id)sender;
- (IBAction)dateofbirthAlertCloseButton:(id)sender;
- (IBAction)mydateofbirthButton:(id)sender;
- (IBAction)myaddressButton:(id)sender;
- (IBAction)cancelButton:(id)sender;
- (IBAction)photoPic:(id)sender;
- (IBAction)updateButton:(id)sender;
- (IBAction)myaddressAlertCloseButton:(id)sender;
- (IBAction)emailAlertCloseButton:(id)sender;
- (IBAction)dateofBirth:(id)sender;
- (IBAction)okButton:(id)sender;

@end
