//
//  VerificationCodeViewController.h
//  uTu
//
//  Created by Sankar on 25/06/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ProfileDetailsViewController.h"
#import "MainTabBarViewController.h"

@interface VerificationCodeViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) MBProgressHUD *mbHUD;

@property (nonatomic, strong) ProfileDetailsViewController *profiledetailsViewController;
@property (nonatomic, strong) MainTabBarViewController *mainTabBarViewController;

@property (weak, nonatomic) IBOutlet UILabel *pleaseenterverificationLabel;
@property (weak, nonatomic) IBOutlet UIButton *skipButton;
@property (weak, nonatomic) IBOutlet UILabel *skipLabel;
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UILabel *doneLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
@property (weak, nonatomic) IBOutlet UILabel *reenterNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *callmewithCodeLabel;


- (IBAction)doneButton:(id)sender;
- (IBAction)skipButton:(id)sender;

@end
