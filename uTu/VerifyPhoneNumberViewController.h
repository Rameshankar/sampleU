//
//  VerifyPhoneNumberViewController.h
//  uTu
//
//  Created by Sankar on 12/04/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileDetailsViewController.h"
#import "MBProgressHUD.h"
#import "CountryListViewController.h"
#import "MainTabBarViewController.h"


@interface VerifyPhoneNumberViewController : UIViewController <UITextFieldDelegate, CountryListViewDelegate>

@property (nonatomic, strong) MBProgressHUD *mbHUD;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *countryListContainerView;
@property (weak, nonatomic) IBOutlet UILabel *countrystdCodeLabel;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *countrylistButton;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIView *verificationCodeView;
@property (weak, nonatomic) IBOutlet UILabel *verifyphoneNumberHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel1;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel2;
@property (weak, nonatomic) IBOutlet UILabel *enterVerificationCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *okLabel;
@property (weak, nonatomic) IBOutlet UILabel *doneLabel;
@property (weak, nonatomic) IBOutlet UILabel *pleaseenterverificationLabel;
@property (weak, nonatomic) IBOutlet UIButton *skipButton;
@property (weak, nonatomic) IBOutlet UILabel *skipLabel;

@property (nonatomic, strong) MainTabBarViewController *mainTabBarViewController;

- (IBAction)countryListButton:(id)sender;
- (IBAction)okButton:(id)sender;
- (IBAction)doneButton:(id)sender;
- (IBAction)skipButton:(id)sender;
@end
