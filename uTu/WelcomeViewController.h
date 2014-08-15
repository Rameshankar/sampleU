//
//  WelcomeViewController.h
//  uTu
//
//  Created by Sankar on 17/04/14.
//  Copyright (c) 2014 ramesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileDetailsViewController.h"
#import "MainTabBarViewController.h"
#import "VerifyPhoneNumberViewController.h"

@interface WelcomeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *termsLabel;
@property (weak, nonatomic) IBOutlet UIButton *agreeButton;
@property (weak, nonatomic) IBOutlet UILabel *agreeLabel;
@property (weak, nonatomic) IBOutlet UILabel *registerLabel;

@property (nonatomic, strong) ProfileDetailsViewController *profiledetailsViewController;
@property (nonatomic, strong) MainTabBarViewController *mainTabBarViewController;
@property (nonatomic, strong) VerifyPhoneNumberViewController *verifyPhoneNumberViewController;

@property (weak, nonatomic) IBOutlet UIImageView *uTuLogoImage;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UILabel *registerheaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *registerViewText;
@property (weak, nonatomic) IBOutlet UIButton *close;
@property (weak, nonatomic) IBOutlet UIView *registerView;
@property (weak, nonatomic) IBOutlet UIView *termsAlertView;
@property (weak, nonatomic) IBOutlet UILabel *termsHeaderLabel;
@property (weak, nonatomic) IBOutlet UILabel *termsBodyLabel;

- (IBAction)agreeButton:(id)sender;
- (IBAction)registerButton:(id)sender;
- (IBAction)registerButton:(id)sender;
- (IBAction)close:(id)sender;
- (IBAction)termsCloseButton:(id)sender;
- (IBAction)termsandConditionsButton:(id)sender;

@end
