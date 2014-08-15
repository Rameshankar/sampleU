//
//  adduTuContactsViewController.h
//  uTu
//
//  Created by Sankar on 22/05/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "CountryListViewController.h"

@interface adduTuContactsViewController : UIViewController <UITextFieldDelegate, CountryListViewDelegate>

@property (nonatomic, strong) MBProgressHUD *mbHUD;
@property (weak, nonatomic) IBOutlet UIView *countryListContainerView;
@property (weak, nonatomic) IBOutlet UILabel *countrystdCodeLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *countrylistButton;
@property (weak, nonatomic) IBOutlet UIView *verificationCodeView;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel1;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel2;
@property (weak, nonatomic) IBOutlet UILabel *countryNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *okLabel;

- (IBAction)countryListButton:(id)sender;
- (IBAction)okButton:(id)sender;

@end
